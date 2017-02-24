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

    # Implicit input
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

    @top_level = top_level || {wires: circuit.split("\n"), index: 0}
    @wire = circuit

    # This prints the stack and component at each iteration (like 05AB1E).
    @debug = debug

    @vars = vars

    # This is so the interpreter doesn't print the top of stack at the end of execution
    @printed = false
  end

  # Executes circuits given in #initialize.
  def exec
    puts "\nActive circuit/wire:\n#{@wire}\n\n" if @debug
    pointer = 0

    while pointer < @wire.length
      current_component = @wire[pointer]

      puts "Component: #{current_component} || Stack: #{@stack}" if @debug && current_component != "\n"

      # Special cases where the behavior can't be described with a lambda
      if /[0-9]/ =~ current_component
        number = @wire[pointer..@wire.length][/[0-9]+/]
        pointer += number.length - 1
        @stack << number
      elsif current_component == '.'
        pointer += 1
        @stack << @wire[pointer]
      elsif current_component == '?'
        execute = true
        else_index = @wire.index("\u00BF")
        cond_end = (@wire.index(';') || @wire.length) - 1

        if @stack.pop
          pointer += 1
          new_circuit_str = @wire[pointer...(else_index &- 1 || cond_end)] # Get circuit string up to else component or end
          puts 'Condition is true, executing if clause' if @debug
        elsif else_index
          pointer = else_index + 1
          new_circuit_str = @wire[pointer..cond_end] # Get circuit string up to end
          puts 'Condition is false, executing else clause' if @debug
        else
          execute = false
          puts 'Condition is false, no else clause, skipping to ";"' if @debug
        end

        if execute
          new_circuit = Ohm.new(new_circuit_str, @debug, @top_level, @stack, @vars).exec
          @printed ||= new_circuit.printed
        end

        pointer = cond_end
      elsif current_component == ':'
        pointer += 1
        new_circuit_str = @wire[pointer..(@wire.index(';') || @wire.length) - 1]

        @stack.pop.each_with_index do |i, v|
          new_vars = @vars.clone
          new_vars[:index] = i
          new_vars[:value] = v

          new_circuit = Ohm.new(new_circuit_str, @debug, @top_level, @stack, new_vars).exec
          @printed ||= new_circuit.printed
        end
      elsif current_component == "\u0398"
        new_index = @top_level.clone
        new_index[:index] -= 1
        Ohm.new(new_index[:wires][new_index[:index]], @debug, new_index, @stack, @vars).exec
      elsif current_component == "\u03A9"
        new_index = @top_level.clone
        new_index[:index] += 1
        Ohm.new(new_index[:wires][new_index[:index]], @debug, new_index, @stack, @vars).exec
      elsif current_component == "\u221E"
        Ohm.new(@top_level[:wires][@top_level[:index]], @debug, @top_level, @stack, @vars).exec
      else
        component_lambda = COMPONENTS[current_component] || ->{} # No-op if component not found
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
