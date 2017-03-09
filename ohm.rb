require_relative 'components'

class Ohm
  class Stack < Array
    def initialize(ohm, *args)
      @ohm = ohm
      super(*args)
    end

    %i(pop last).each do |i|
      define_method(i) do |n = 1|
        len = length # The length changes after the call to `super`, so we get it first.
        result = super(n)
        if n > len
          (n - len).times {result << @ohm.instance_exec(&@ohm.method(:input))}
        end
        result
      end
    end
  end

  DEFAULT_VARS = {
    # Like 05AB1E, there is an integer counter that can only be incremented.
    counter: 0,
    # However, like Jelly, there is only one register that can store any given value.
    register: 1,
    # These are the default values for the variables that store the index and value of the current element in a loop.
    # They correspond to 'N' and 'y' in 05AB1E.
    index: 2,
    value: 5
  }

  attr_accessor :counter, :register
  attr_reader :broken, :inputs, :stack, :printed, :vars

  # Represents an Ohm circuit.
  def initialize(circuit, debug, top_level = nil, stack = Stack.new(self), inputs = [], vars = DEFAULT_VARS)
    @stack = stack

    @inputs = inputs

    @top_level = top_level || {wires: circuit.split("\n"), index: 0}
    raise IndexError, "invalid wire index #{@top_level[:index]}" if @top_level[:wires][@top_level[:index]].nil?

    @wire = circuit

    # This prints the stack and component at each iteration (like 05AB1E).
    @debug = debug

    @vars = vars

    # This is so the interpreter doesn't print the top of stack at the end of execution
    @printed = false

    @broken = false
  end

  # Executes circuits given in #initialize.
  def exec
    puts "\nActive circuit:\n#{@wire}\n\n" if @debug
    @pointer = 0

    while @pointer < @wire.length
      @component = @wire[@pointer]
      break if @component == "\n"
      puts "Component: #{@component} || Stack: #{@stack}" if @debug

      # Special cases where the behavior can't be described with a concise lambda
      # Literals
      case @component
      when /[0-9]/ # Number literal
        number = @wire[@pointer..@wire.length][/[0-9]+/]
        @pointer += number.length - 1
        @stack << number
      when '.' # Character literal
        @pointer += 1
        @stack << @wire[@pointer]
      when '"' # String literal
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index('"')
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << @wire[@pointer...lit_end]
        @pointer = lit_end
      when "\u2551" # Base-220 number literal
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index("\u2551")
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << from_base(@wire[@pointer...lit_end], BASE_DIGITS.length)
        @pointer = lit_end
      # Conditionals/loops
      when '?'
        @pointer += 1

        else_index = outermost_delim(@wire[@pointer..@wire.length], "\u00BF", OPENERS)
        else_index += @pointer unless else_index.nil?
        cond_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        cond_end = cond_end.nil? ? @wire.length : cond_end + @pointer

        execute = true

        if @stack.pop[0]
          block_str = @wire[@pointer...(else_index || cond_end)] # Get block string up to else component or end
          puts 'Condition is true, executing if block' if @debug
        elsif else_index
          block_str = @wire[(else_index + 1)...cond_end] # Get block string up to end
          puts 'Condition is false, executing else block' if @debug
        else
          execute = false
          puts 'Condition is false, no else clause, skipping to ";" or end' if @debug
        end

        if execute
          block = Ohm.new(block_str, @debug, @top_level, @stack, @inputs, @vars).exec
          @printed ||= block.printed
          @stack = block.stack
          @broken = block.broken
        end

        @pointer = cond_end
      when ':'
        @pointer += 1
        loop_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        loop_end = loop_end.nil? ? @wire.length : loop_end + @pointer

        popped = @stack.pop[0]

        (popped.is_a?(String) ? popped.each_char : popped).each_with_index do |v, i|
          new_vars = @vars.clone
          new_vars[:value] = v
          new_vars[:index] = i

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @top_level, @stack, @inputs, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
          break if block.broken
        end

        @pointer = loop_end
      when 'M'
        @pointer += 1
        loop_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        loop_end = loop_end.nil? ? @wire.length : loop_end + @pointer

        popped = @stack.pop[0]

        popped.to_i.times do |i|
          new_vars = @vars.clone
          new_vars[:index] = i

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @top_level, @stack, @inputs, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
          break if block.broken
        end

        @pointer = loop_end
      when "\u221E"
        @pointer += 1
        loop_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        loop_end = loop_end.nil? ? @wire.length : loop_end + @pointer

        counter = 0
        loop do
          new_vars = @vars.clone
          new_vars[:index] = counter

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @top_level, @stack, @inputs, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
          break if block.broken
          counter += 1
        end

        @pointer = loop_end
      when "\u00BB"
        @pointer += 1
        @component = @wire[@pointer]

        # Multi-character component support
        if COMPONENTS[@component].is_a?(Hash)
          @pointer += 1
          @component << @wire[@pointer]
        end

        @stack << @stack.pop[0].map do |e|
          comp = Ohm.new(@component, @debug, @top_level, @stack.clone << e, @inputs, @vars).exec
          @printed ||= comp.printed
          break if comp.broken
          comp.stack.last[0]
        end
      # Array operations
      when "\u2591"
        arr_operation(:select)
      when "\u2592"
        arr_operation(:reject)
      when "\u2593"
        arr_operation(:map)
      when "\u2560"
        arr_operation(:sort_by)
      when "\u2568"
        arr_operation(:max_by)
      when "\u2565"
        arr_operation(:min_by)
      when "\u256B"
        arr_operation(:minmax_by)
      # By default, Enumerable#all? and #any? return a boolean instead of an enumerator if no block was given
      # So in order to keep everything DRY, we'll just map over the block and call the method on the resulting array
      when "\u00C5"
        arr_operation(:map)
        @stack << @stack.pop[0].all?
      when "\u00C9"
        arr_operation(:map)
        @stack << @stack.pop[0].any?
      # Special behavior for calling wires
      when "\u03A6"
        exec_wire_at_index(@stack.pop[0].to_i)
      when "\u0398"
        exec_wire_at_index(@top_level[:index] - 1)
      when "\u03A9"
        exec_wire_at_index(@top_level[:index] + 1)
      # Break statement
      when "\u25A0"
        if @stack.pop[0]
          @broken = true
          puts 'Breaking out of current wire/block' if @debug
          break
        end
      else
        comp_lambda = 
          case COMPONENTS[@component]
          when Hash # Multi-character component
            @pointer += 1
            l = COMPONENTS[@component][@wire[@pointer]]
            @component << @wire[@pointer]
            l
          when nil # Component not found
            ->{} # No-op
          else
            COMPONENTS[@component]
          end

        args = @stack.method(
          STACK_GET.include?(@component) ? :last : :pop
        ).call(comp_lambda.arity)

        result = instance_exec(*args, &comp_lambda)

        unless result.nil? && !PUSH_NILS.include?(@component)
          if MULTIPLE_PUSH.include?(@component)
            @stack.push(*result)
          else
            @stack << result
          end
        end
      end

      @pointer += 1
    end

    self
  end
end
