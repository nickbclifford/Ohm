require 'set'

require_relative 'constants'

class Ohm
  module Helpers
    module_function

    def ackermann(x, y)
      if x.zero?
        y + 1
      elsif y.zero?
        ackermann(x - 1, 1)
      else
        ackermann(x - 1, ackermann(x, y - 1))
      end
    end

    def arr_else_str(arg)
      arg.is_a?(Array) ? arg : untyped_to_s(arg)
    end

    def arr_else_chars(arg)
      arg.is_a?(Array) ? arg : untyped_to_s(arg).chars
    end

    def arr_else_chars_join(arg, &block)
      result = block.call(arr_else_chars(arg))

      arg.is_a?(Array) ? result : result.join
    end

    def arr_else_chars_inner_join(arg, &block)
      result = block.call(arr_else_chars(arg))

      arg.is_a?(Array) ? result : result.map(&:join)
    end

    def arr_operation(meth, amount_pop = nil)
      @pointer += 1
      loop_end = outermost_delim(@wire[@pointer..@wire.length], ';', OPENERS)
      loop_end = loop_end.nil? ? @wire.length : loop_end + @pointer

      popped = @stack.pop[0]

      @stack << arr_else_chars(popped).method(meth).call(*(@stack.pop(amount_pop) unless amount_pop.nil?)).each_with_index do |v, i|
        new_vars = @vars.clone
        new_vars[:value] = v
        new_vars[:index] = i

        block = Ohm.new(@wire[@pointer...loop_end], @debug, @top_level, @stack, @inputs, new_vars).exec
        @printed ||= block.printed
        @stack = block.stack
        break if block.broken
        @stack.pop[0] unless @stack.last[0].nil?
      end

      @pointer = loop_end
    end

    def arr_or_stack(arg, &block)
      if arg.is_a?(Array)
        block.call(arg)
      else
        @stack = Stack.new(self, [block.call(@stack << arg)]) # The argument gets popped, so we have to push it back
        nil
      end
    end

    def factorial(n)
      (1..n).reduce(1, :*)
    end

    def fibonacci?(n)
      perf_sqr = ->(x){Math.sqrt(x).to_i == Math.sqrt(x)}
      perf_sqr.call(5 * (n ** 2) + 4) || perf_sqr.call(5 * (n ** 2) + 4)
    end

    def fibonacci_upto(n)
      result = [1, 1]
      i = 2
      while result.last < n
        result << result[i - 1] + result[i - 2]
        i += 1
      end
      result.pop if result.last > n
      result
    end

    def from_base(str, base)
      str.reverse.each_char.each_with_index.reduce(0) do |memo, kv|
        char, i = kv
        memo + (BASE_DIGITS.index(char) * (base ** i))
      end
    end

    def input
      i = $stdin.gets.chomp
      @inputs << x = 
        if /\[(.*?)\]/ =~ i || i == 'true' || i == 'false'
          eval(i)
        else
          i
        end
      x
    end

    def input_access(i)
      if @inputs[i].nil?
        input
      else
        @inputs[i]
      end
    end

    def nCr(n, r)
      nPr(n, r) / factorial(r)
    end

    def nth_fibonacci(n, memo = {}) # Memoization makes it really fast
      return n if (0..1).include?(n)
      memo[n] ||= nth_fibonacci(n - 1, memo) + nth_fibonacci(n - 2, memo)
    end

    def nPr(n, r)
      factorial(n) / factorial(n - r)
    end

    def outermost_delim(str, delim, openers)
      amount_open = 1

      str.each_char.each_with_index do |char, i|
        amount_open += 1 if openers.include?(char)
        amount_open -= 1 if char == delim
        return i if amount_open.zero?
      end

      # Return nil if no delimiter found
      nil
    end

    def powerset(set)
      return [set] if set.empty?

      popped = set.pop
      subset = powerset(set)
      subset | subset.map {|a| a | [popped]}
    end

    # Partially adapted from a Python answer on StackOverflow
    def perfect_exp?(int, exp)
      x = int.div(exp)
      seen = Set.new([x])
      until (x ** exp) == int
        x = 1 if x.zero?
        x = (((exp - 1) * x) + int.div(x ** (exp - 1))).div(exp)
        return false if seen.include?(x)
        seen << x
      end
      true
    end

    def subarray_index(haystack, needle)
      haystack.each_index do |i|
        return 1 + i if haystack[i...i + needle.length] == needle
      end
      0
    end

    def to_base(num, base)
      # Special cases
      return '0' if num.zero?

      if num.negative? || !base.between?(2, BASE_DIGITS.length)
        if num.positive? && base == 1
          # Unary
          '0' * num
        else
          # Empty string if invalid
          ''
        end
      else
        num_converted = ''

        until num.zero?
          num_converted << BASE_DIGITS[num % base]
          num = num.div(base) # Amputate last digit
        end

        num_converted.reverse.sub(/^0+/, '') # Remove leading zeroes
      end
    end

    def untyped_to_s(n)
      n.is_a?(Numeric) ? format("%.#{n.to_s.length}g", n) : n.to_s
    end

    def exec_wire_at_index(i)
      new_index = @top_level.clone
      new_index[:index] = i

      puts "Executing wire at index #{i}" if @debug
      new_wire = Ohm.new(new_index[:wires][new_index[:index]], @debug, new_index, @stack, @inputs, @vars).exec
      @printed ||= new_wire.printed
      @stack = new_wire.stack

      puts "Done executing wire at index #{i}\n" if @debug
    end
  end
end
