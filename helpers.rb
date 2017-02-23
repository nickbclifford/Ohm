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

    def nCr(n, r)
      nPr(n, r) / factorial(r)
    end

    def nPr(n, r)
      factorial(n) / factorial(n - r)
    end

    def untyped_to_s(n)
      n.is_a?(Numeric) ? format('%g', n) : n.to_s
    end
  end
end
