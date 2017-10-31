require_relative 'lib/components'
require_relative 'lib/smaz'

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
    # Like 05AB1E, there is an integer counter that can only be incremented (and reset to 0).
    counter: 0,
    # However, like Jelly, there is only one register that can store any given value.
    register: 1,
    # These are the default values for the variables that store the index and value of the current element in a loop.
    # They correspond to 'N' and 'y' in 05AB1E.
    index: 2,
    value: 5
  }

  attr_accessor :counter, :register
  attr_reader :broken, :inputs, :safe, :stack, :printed, :vars

  # Represents an Ohm circuit.
  def initialize(circuit, debug, safe = false, top_level = nil, stack = Stack.new(self), inputs = [], vars = DEFAULT_VARS)
    @stack = stack

    @inputs = inputs

    @top_level = top_level || {wires: circuit.split(/[\n¶](?![^#{QUOTES.join}]*[#{QUOTES.join}])/), index: 0}
    raise IndexError, "invalid wire index #{@top_level[:index]}" if @top_level[:wires][@top_level[:index]].nil?

    @wire = circuit

    # This prints the stack and component at each iteration (like 05AB1E).
    @debug = debug

    # Disables components that perform network requests, etc.
    @safe = safe

    @vars = vars

    @exit = false

    # This is so the interpreter doesn't print the top of stack at the end of execution
    @printed = false

    @broken = false
  end

  # Executes circuits given in #initialize.
  def exec
    puts "\nActive circuit:\n#{@wire}\n\n" if @debug
    @pointer = 0

    while @pointer < @wire.length
      return self if @exit
      @component = @wire[@pointer]

      comp_hash = COMPONENTS[@component] || {nop: true}

      # Check if multi-char component
      if comp_hash.keys.all? {|k| k.is_a?(String)}
        @component << next_comp = @wire[@pointer += 1]
        comp_hash = comp_hash[next_comp]
      end

      break if @component == "\n" || @component == '¶'
      puts "Component: #{@component} || Stack: #{@stack}" if @debug

      # Special cases where the behavior can't be described with a concise lambda
      # Keyword in that sentence is "concise"
      # Otherwise, most of these could _technically_ become lambdas
      case @component
      # Extended components
      when '·Ω'
        @stack << find_cycle_component
      when '·Θ'
        @stack << find_cycle_component.last
      # Literals
      when /^[0-9]$/ # Number literal
        number = @wire[@pointer..@wire.length][/[0-9]+/]
        @pointer += number.length - 1
        @stack << number
      when '.' # Character literal
        @stack << @wire[@pointer += 1]
      when '‥' # Two-character literal
        @pointer += 1
        @stack << @wire[@pointer..(@pointer += 1)]
      when '…' # Three-character literal
        @pointer += 1
        @stack << @wire[@pointer..(@pointer += 2)]
      when '"' # String literal
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index('"')
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << @wire[@pointer...lit_end].gsub('¶', "\n")
        @pointer = lit_end
      when '“' # Base-255 number literal
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index('“')
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << from_base(@wire[@pointer...lit_end], BASE_DIGITS.length)
        @pointer = lit_end
      when '”' # Smaz-compressed string literal
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index('”')
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << Smaz.decompress(@wire[@pointer...lit_end])
        @pointer = lit_end
      when '᠁'
        @pointer += 1
        lit_end = @wire[@pointer..@wire.length].index('᠁')
        lit_end = lit_end.nil? ? @wire.length : lit_end + @pointer

        @stack << ohm_to_bin(@wire[@pointer...lit_end])
        @pointer = lit_end
      # Miscellaneous
      when ']'
        @stack.push(*@stack.pop[0])
      when 'q' # Quit prematurely
        @exit = true
        break
      # Conditionals/loops
      when '?'
        @pointer += 1

        else_index = outermost_delim(@wire[@pointer..@wire.length], '¿', OPENERS)
        else_index += @pointer unless else_index.nil?
        cond_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        cond_end = cond_end.nil? ? @wire.length : cond_end + @pointer

        execute = true

        if truthy?(@stack.pop[0])
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
          block = Ohm.new(block_str, @debug, @safe, @top_level, @stack, @inputs, @vars).exec
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

        arr_else_chars(popped).each_with_index do |v, i|
          new_vars = @vars.clone
          new_vars[:value] = v
          new_vars[:index] = i

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @safe, @top_level, @stack, @inputs, new_vars).exec
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

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @safe, @top_level, @stack, @inputs, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
          break if block.broken
        end

        @pointer = loop_end
      when '£'
        @pointer += 1
        loop_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
        loop_end = loop_end.nil? ? @wire.length : loop_end + @pointer

        counter = 0
        loop do
          new_vars = @vars.clone
          new_vars[:index] = counter

          block = Ohm.new(@wire[@pointer...loop_end], @debug, @safe, @top_level, @stack, @inputs, new_vars).exec
          @printed ||= block.printed
          @stack = block.stack
          break if block.broken
          counter += 1
        end

        @pointer = loop_end
      when '¡' # Reduce
        @pointer += 1
        @component = @wire[@pointer]

        # Multi-character component support
        @component << @wire[@pointer += 1] if COMPONENTS[@component].keys.all? {|k| k.is_a?(String)}

        @stack << @stack.pop[0].reduce do |m, e|
          comp = Ohm.new(@component, @debug, @safe, @top_level, @stack.clone << m << e, @inputs, @vars).exec
          @printed ||= comp.printed
          break if comp.broken
          comp.stack.last[0]
        end
      when '¤' # Cumulative reduce
        @pointer += 1
        @component = @wire[@pointer]

        # Multi-character component support
        @component << @wire[@pointer += 1] if COMPONENTS[@component].keys.all? {|k| k.is_a?(String)}

        head, *tail = @stack.pop[0]
        @stack << tail.reduce([head]) do |m, e|
          comp = Ohm.new(@component, @debug, @safe, @top_level, @stack.clone << m.last << e, @inputs, @vars).exec
          @printed ||= comp.printed
          break if comp.broken
          m << comp.stack.last[0]
        end
      when '»'
        @pointer += 1
        @component = @wire[@pointer]

        # Multi-character component support
        @component << @wire[@pointer += 1] if COMPONENTS[@component].keys.all? {|k| k.is_a?(String)}

        @stack << @stack.pop[0].map do |e|
          comp = Ohm.new(@component, @debug, @safe, @top_level, @stack.clone << e, @inputs, @vars).exec
          @printed ||= comp.printed
          break if comp.broken
          comp.stack.last[0]
        end
      # Array operations
      when '⁇'
        arr_operation(:select)
      when '⁈'
        arr_operation(:partition)
      when '‼'
        arr_operation(:reject)
      when '€'
        arr_operation(:map)
      when 'ς'
        arr_operation(:sort_by)
      when '‘'
        arr_operation(:min_by)
      when '’'
        arr_operation(:max_by)
      when 'χ'
        arr_operation(:minmax_by)
      # By default, Enumerable#all? and #any? return a boolean instead of an enumerator if no block was given
      # So in order to keep everything DRY, we'll just map over the block and call the method on the resulting array
      when 'Å'
        arr_operation(:map)
        @stack << (@stack.pop[0].all?(&method(:truthy?)) ? 1 : 0)
      when 'É'
        arr_operation(:map)
        @stack << (@stack.pop[0].any?(&method(:truthy?)) ? 1 : 0)
      # Special behavior for calling wires
      when 'Ψ'
        exec_wire_at_index(@top_level[:index])
      when 'Φ'
        exec_wire_at_index(@stack.pop[0].to_i)
      when 'Θ'
        exec_wire_at_index(@top_level[:index] - 1)
      when 'Ω'
        exec_wire_at_index(@top_level[:index] + 1)
      # Break statement
      when '‽'
        if truthy?(@stack.pop[0])
          @broken = true
          puts 'Breaking out of current wire/block' if @debug
          break
        end
      else
        comp_hash ||= {nop: true}

        comp_hash[:call] ||= ->{}

        args = @stack.method(
          comp_hash[:get] ? :last : :pop
        ).call(comp_hash[:call].arity)

        result = exec_component_hash(args, comp_hash) unless comp_hash[:unsafe] && @safe

        unless result.nil?
          if comp_hash[:multi]
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
