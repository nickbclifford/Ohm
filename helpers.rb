require_relative 'constants'

class Ohm
  module Helpers
    module_function

    def arr_or_stack(arg, &block)
      if arg.is_a?(Array)
        block.call(arg)
      else
        @stack = [block.call(@stack << arg)] # The argument gets popped, so we have to push it back
        nil
      end
    end

    def factorial(n)
      (1..n).reduce(1, :*)
    end

    def from_base(str, base)
      str.reverse.each_char.each_with_index.reduce(0) do |memo, kv|
        char, i = kv
        memo + (BASE_DIGITS.index(char) * (base ** i))
      end
    end

    def nCr(n, r)
      nPr(n, r) / factorial(r)
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

        num_converted.sub(/^0+/, '').reverse # Remove leading zeroes
      end
    end

    def untyped_to_s(n)
      n.is_a?(Numeric) ? format("%.#{n.to_s.length}g", n) : n.to_s
    end
  end
end
