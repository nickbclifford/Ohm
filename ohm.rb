require 'optparse'

require_relative 'components'

trap('SIGINT') {exit!}

class Ohm
  # It makes me sad that 0x00-1F in CP437 are generally interpreted as control characters instead of smileys like Wikipedia shows :(
  CODE_PAGE = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstu
vwxyz{|}~\u00C7\u00FC\u00E9\u00E2\u00E4\u00E0\u00E5\u00E7\u00EA\u00EB\u00E8\u00EF\u00EE\u00EC\u00C4\u00C5\u00C9\u00E6\u00C6\u00F4\u00F6\u00F2\u00FB\u00F9\u00FF\u00D6\u00DC\u00A2\u00A3\u00A5\u20A7\u0192\u00E1\u00ED\u00F3\u00FA\u00F1\u00D1\u00AA\u00BA\u00BF\u2310\u00AC\u00BD\u00BC\u00A1\u00AB\u00BB\u2591\u2592\u2593\u2502\u2524\u2561\u2562\u2556\u2555\u2563\u2551\u2557\u255D\u255C\u255B\u2510\u2514\u2534\u252C\u251C\u2500\u253C\u255E\u255F\u255A\u2554\u2569\u2566\u2560\u2550\u256C\u2567\u2568\u2564\u2565\u2559\u2558\u2552\u2553\u256B\u256A\u2518\u250C\u2588\u2584\u258C\u2590\u2580\u03B1\u00DF\u0393\u03C0\u03A3\u03C3\u00B5\u03C4\u03A6\u0398\u03A9\u03B4\u221E\u03C6\u03B5\u2229\u2261\u00B1\u2265\u2264\u2320\u2321\u00F7\u2248\u00B0\u2219\u00B7\u221A\u207F\u00B2\u25A0"
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
  DICTIONARY = File.read(File.expand_path('./dictionary.txt')).split("\n")

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
        if n > len
          (n - len).times {result << $stdin.gets.chomp}
        end
        result.length > 1 || result[0].is_a?(Array) ? result : result[0]
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
          new_circuit_str = @wire[pointer..((else_index &- 1 || cond_end) - 1)] # Get circuit string up to else component or end
          puts 'Condition is true, executing if clause' if @debug
        elsif else_index
          pointer = else_index + 1
          p @wire[pointer..cond_end]
          new_circuit_str = @wire[pointer..cond_end] # Get circuit string up to end
          puts 'Condition is false, executing else clause' if @debug
        else
          execute = false
          puts 'Condition is false, no else clause, skipping to ";"' if @debug
        end

        if execute
          new_circuit = Ohm.new(new_circuit_str, @debug, @top_level, @stack, @vars).exec
          @printed ||= new_circuit.printed
          # @stack = new_circuit.stack
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
          # @stack = new_circuit.stack
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

opts = {
  debug: false,
  encoding: 'utf-8',
  eval: false
}

ARGV << '-h' if ARGV.empty? # Print help if no arguments passed

OptionParser.new do |parser|
  parser.banner << ' <circuit>' # This is ARGV[0] after parsing
  parser.on('-c', '--cp437', 'Read file <circuit> with CP-437 encoding') {opts[:encoding] = 'cp437'}
  parser.on('-d', '--debug', 'Enter debug mode') {opts[:debug] = true}
  parser.on('-e', '--eval', 'Evaluate <circuit> as Ohm code') {opts[:eval] = true}
  parser.on('-h', '--help', 'Prints this help') {puts parser; exit}
end.parse!

circuit = Ohm.new(opts[:eval] ? ARGV[0] : File.read(ARGV[0], opts).encode('utf-8').strip, opts[:debug]).exec
Ohm::Helpers.untyped_puts(circuit.stack.last) unless circuit.printed
puts "Stack at end of circuit: #{circuit.stack}" if opts[:debug]
