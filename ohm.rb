require_relative 'components'

class Ohm
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
  attr_reader :stack, :printed

  # Represents an Ohm circuit.
  def initialize(circuit, debug, top_level = nil, stack = [], vars = DEFAULT_VARS)
    @stack = stack

    # Only define singleton methods if top-level
    if top_level.nil?
      %i(pop last).each do |i|
        @stack.define_singleton_method(i) do |n=1|
          len = length # The length changes after the call to `super`, so we get it first.
          result = super(n)
          result = result[0] if n == 1
          if n > len
            (n - len).times {result << $stdin.gets.chomp}
          end
          result
        end
      end
    end

    @top_level = top_level || {wires: circuit.split("\n"), index: 0}
    raise IndexError, "invalid wire index #{@top_level[:index]}" if @top_level[:wires][@top_level[:index]].nil?

    @wire = circuit

    # This prints the stack and component at each iteration (like 05AB1E).
    @debug = debug

    @vars = vars

    # This is so the interpreter doesn't print the top of stack at the end of execution
    @printed = false
  end

  # Executes circuits given in #initialize.
  def exec
    puts "\nActive circuit:\n#{@wire}\n\n" if @debug
    pointer = 0

    while pointer < @wire.length
      current_component = @wire[pointer]
      break if current_component == "\n"
      puts "Component: #{current_component} || Stack: #{@stack}" if @debug

      # Special cases where the behavior can't be described with a concise lambda
      # Literals
      case current_component
      when /[0-9]/ # Number literal
        number = @wire[pointer..@wire.length][/[0-9]+/]
        pointer += number.length - 1
        @stack << number
      when '.' # Character literal
        pointer += 1
        @stack << @wire[pointer]
      when '"' # String literal
        pointer += 1
        lit_end = @wire[pointer..@wire.length].index('"')
        lit_end = lit_end.nil? ? @wire.length : lit_end + pointer

        @stack << @wire[pointer...lit_end]
        pointer = lit_end
      when "\u2551" # Base-221 number literal
        pointer += 1
        lit_end = @wire[pointer..@wire.length].index("\u2551")
        lit_end = lit_end.nil? ? @wire.length : lit_end + pointer

        @stack << from_base(@wire[pointer...lit_end], BASE_DIGITS.length)
        pointer = lit_end
      # Conditionals/loops
      when '?'
        pointer += 1

        else_index = outermost_delim(@wire[pointer..@wire.length], "\u00BF", OPENERS)
        else_index += pointer unless else_index.nil?
        cond_end = outermost_delim(@wire[pointer..@wire.length], ';', OPENERS)
        cond_end = cond_end.nil? ? @wire.length : cond_end + pointer

        execute = true

        if @stack.pop
          block_str = @wire[pointer...(else_index || cond_end)] # Get block string up to else component or end
          puts 'Condition is true, executing if block' if @debug
        elsif else_index
          block_str = @wire[(else_index + 1)...cond_end] # Get block string up to end
          puts 'Condition is false, executing else block' if @debug
        else
          execute = false
          puts 'Condition is false, no else clause, skipping to ";" or end' if @debug
        end

        if execute
          block = Ohm.new(block_str, @debug, @top_level, @stack, @vars).exec
          @printed ||= block.printed
          @stack = block.stack
        end

        pointer = cond_end
      when ':'
        pointer += 1
        loop_end = outermost_delim(@wire[pointer..@wire.length], ';', OPENERS)
        loop_end = loop_end.nil? ? @wire.length : loop_end + pointer

        popped = @stack.pop

        (popped.is_a?(String) ? popped.each_char : popped).each_with_index do |v, i|
          new_vars = @vars.clone
          new_vars[:value] = v
          new_vars[:index] = i

          block = Ohm.new(@wire[pointer...loop_end], @debug, @top_level, @stack, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
        end

        pointer = loop_end
      # Special behavior for calling wires
      when "\u03A6"
        instance_exec(@stack.pop.to_i, &method(:exec_wire_at_index))
      when "\u0398"
        instance_exec(@top_level[:index] - 1, &method(:exec_wire_at_index))
      when "\u03A9"
        instance_exec(@top_level[:index] + 1, &method(:exec_wire_at_index))
      when "\u221E"
        instance_exec(&method(:exec_wire_at_index))
      else
        component_lambda =
          case COMPONENTS[current_component]
          when Hash # Multi-character component
            pointer += 1
            COMPONENTS[current_component][@wire[pointer]]
          when nil # Component not found
            ->{} # No-op
          else
            COMPONENTS[current_component]
          end

        stack_mode = STACK_GET.include?(current_component) ? :last : :pop

        result = instance_exec(*@stack.method(stack_mode).call(component_lambda.arity), &component_lambda)
        unless result.nil?
          if MULTIPLE_PUSH.include?(current_component)
            @stack.push(*result)
          else
            @stack << result
          end
        end
      end

      pointer += 1
    end

    self
  end
end
