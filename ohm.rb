require 'optparse'

require_relative 'commands'

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

  # Represents an Ohm program.
  def initialize(program, debug, stack = [], vars = DEFAULT_VARS)
    @stack = stack
    @program = program

    # This prints the stack and command at each iteration (like 05AB1E).
    @debug = debug

    @vars = vars

    # This is so the interpreter doesn't print the top of stack at the end of execution
    @printed = false
  end

  # Executes program given in #initialize.
  def exec
    puts "Full program: #{@program}" if @debug
    pointer = 0

    while pointer < @program.length
      current_command = @program[pointer]

      puts "Command: #{current_command} || Stack: #{@stack}" if @debug

      # Special cases where the behavior can't be described with a lambda
      if /[0-9]/ =~ current_command
        number = @program[pointer..@program.length][/[0-9]+/]
        pointer += number.length - 1
        @stack << number
      elsif current_command == '.'
        pointer += 1
        @stack << @program[pointer]
      elsif current_command == '?'
        execute = true
        else_index = @program.index("\u00BF")
        cond_end = (@program.index(';') || @program.length) - 1

        if @stack.pop
          pointer += 1
          new_prog_str = @program[pointer..(else_index &- 1 || cond_end)] # Get program string up to else command or end
          puts "Condition is true, executing if clause \"#{new_prog_str}\"" if @debug
        elsif else_index
          pointer = else_index + 1
          new_prog_str = @program[pointer..cond_end] # Get program string up to end
          puts "Condition is false, executing else clause \"#{new_prog_str}\"" if @debug
        else
          execute = false
          puts 'Condition is false, no else clause, skipping to ";"' if @debug
        end

        if execute
          new_program = Ohm.new(new_prog_str, @debug, @stack, @vars).exec
          @printed ||= new_program.printed
          @stack = new_program.stack
        end

        pointer = cond_end
      elsif current_command == ':'
        pointer += 1
        new_prog_str = @program[pointer..(@program.index(';') || @program.length) - 1]

        @stack.pop.each_with_index do |i, v|
          new_vars = @vars.clone
          new_vars[:index] = i
          new_vars[:value] = v

          new_program = Ohm.new(new_prog_str, @debug, @stack, new_vars).exec
          @printed ||= new_program.printed
          @stack = new_program.stack
        end
      else
        command_lambda = COMMANDS[current_command] || ->{} # No-op if command not found
        stack_mode = STACK_GET.include?(current_command) ? :last : :pop

        result = instance_exec(*@stack.method(stack_mode).call(command_lambda&.arity), &command_lambda)
        unless result.nil?
          if MULTIPLE_PUSH.include?(current_command)
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
  parser.banner << ' <program>' # This is ARGV[0] after parsing
  parser.on('-c', '--cp437', 'Read file <program> with CP-437 encoding') {opts[:encoding] = 'cp437'}
  parser.on('-d', '--debug', 'Enter debug mode') {opts[:debug] = true}
  parser.on('-e', '--eval', 'Evaluate <program> as Ohm code') {opts[:eval] = true}
  parser.on('-h', '--help', 'Prints this help') {puts parser; exit}
end.parse!

program = Ohm.new(opts[:eval] ? ARGV[0] : File.read(ARGV[0], opts).encode('utf-8'), opts[:debug]).exec
tos = program.stack.last

Ohm::Helpers.untyped_puts((tos.is_a?(Array) ? tos.inspect : tos)) unless program.printed
puts "Stack at end of program: #{program.stack}" if opts[:debug]
