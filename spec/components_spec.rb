RSpec.describe Ohm do
  describe 'components' do
    describe '°' do
      include_examples 'component', 'all given inputs', inputs: %w(foo bar baz quux), result: %w(foo bar baz quux)
    end
    describe '¹' do
      include_examples 'not implemented'
    end
    describe '²' do
      include_examples 'component', 'a number squared', stack: [5], result: 25
    end
    describe '³' do
      include_examples 'component', 'the first input', inputs: %w(foo bar baz quux), result: 'foo'
    end
    describe '⁴' do
      include_examples 'component', 'the second input', inputs: %w(foo bar baz quux), result: 'bar'
    end
    describe '⁵' do
      include_examples 'component', 'the third input', inputs: %w(foo bar baz quux), result: 'baz'
    end
    describe '⁶' do
      include_examples 'component', 'the input at the given index', stack: [3], inputs: %w(foo bar baz quux), result: 'quux'
    end
    describe '⁷' do
      include_examples 'component', '16', result: 16
    end
    describe '⁸' do
      include_examples 'component', '100', result: 100
    end
    describe '⁹' do
      include_examples 'component', 'the value of the counter variable', result: 0
    end
    describe '⁺' do
      it 'increments the counter variable' do
        expect(Ohm.new('⁺').exec.vars[:counter]).to eq(1)
      end
    end
    describe '⁻' do
      it 'resets the counter variable to 0' do
        expect(Ohm.new('⁻', vars: Ohm::DEFAULT_VARS.merge(counter: 1)).exec.vars[:counter]).to eq(0)
      end
    end
    describe '⁼' do
      include_examples 'component', 'whether two objects are equal (without vectorization)', stack: [[1, 2], [2, 1]], result: 0
    end
    describe '⁽' do
      include_examples 'component', 'the first element in an array (without vectorization)', stack: [[[1, 2], [3, 4]]], result: [1, 2]
    end
    describe '⁾' do
      include_examples 'component', 'the last element in an array (without vectorization)', stack: [[[1, 2], [3, 4]]], result: [3, 4]
    end
    describe 'ⁿ' do
      include_examples 'component', 'the exponentiation of two numbers', stack: [4, 3], result: 64
    end
    describe '½' do
      include_examples 'component', 'a number halved', stack: [3], result: 1.5
    end
    describe '⅓' do
      include_examples 'not implemented'
    end
    describe '¼' do
      include_examples 'not implemented'
    end
    describe '←' do
      include_examples 'component', 'an array with an object prepended to it', stack: [[4, 3, 2], 1], result: [1, 4, 3, 2]
    end
    describe '↑' do
      include_examples 'component', 'the maximum element of an array', stack: [[2, 5, 3, 3]], result: 5
    end
    describe '→' do
      include_examples 'component', 'an array with an object appended to it', stack: [[4, 3, 2], 1], result: [4, 3, 2, 1]
    end
    describe '↓' do
      include_examples 'component', 'the minimum element of an array', stack: [[2, 5, 3, 3]], result: 2
    end
    describe '↔' do
      include_examples 'component', 'two arrays or strings concatenated together', stack: ['foo', 'bar'], result: 'foobar'
    end
    describe '↕' do
      include_examples 'component', 'an array containing the minimum and maximum element of the given array', stack: [[2, 5, 3, 3]], result: [2, 5]
    end
    describe 'ı' do
      include_examples 'component', 'a number rounded up to the nearest integer', stack: [3.88], result: 4
    end
    describe 'ȷ' do
      include_examples 'component', 'a number rounded down to the nearest integer', stack: [3.88], result: 3
    end
    describe '×' do
      include_examples 'component', 'a string repeated a certain amount of times', stack: ['foo', 3], result: 'foofoofoo'
    end
    describe '÷' do
      include_examples 'component', 'the reciprocal of a number', stack: [2], result: 0.5
    end
    describe '£' do
      it 'runs the given block infinitely' do
        # RSpec magic
        expect(ohm = Ohm.new('£')).to receive(:loop).and_yield
        ohm.exec
      end
    end
    describe '¥' do
      include_examples 'component', 'whether one number is divisible by another', stack: [45, 3], result: 1
    end
    describe '€' do
      include_examples 'component', 'the result of applying the given block to an array', stack: [[1, 2, 3]], circuit: '€2+', result: [3, 4, 5]
    end
    describe '!' do
      include_examples 'component', 'the factorial of a number', stack: [5], result: 120
    end
    describe '"' do
      include_examples 'component', 'a string literal', circuit: '"foobar"', result: 'foobar'
    end
    describe '#' do
      include_examples 'component', 'the range from 0 to a number', stack: [7], result: [0, 1, 2, 3, 4, 5, 6, 7]
    end
    describe '$' do
      include_examples 'component', 'the current value of the register', result: 1
    end
    describe '%' do
      include_examples 'component', 'the modulus of two numbers', stack: [5, 3], result: 2
    end
    describe '&' do
      include_examples 'component', 'the AND of two booleans', stack: [1, 0], result: 0
    end
    describe "'" do
      include_examples 'component', 'the character with the given char code', stack: [33], result: '!'
    end
    describe '(' do
      include_examples 'component', 'an array without the first element', stack: [[1, 2, 3, 4]], result: [2, 3, 4]
    end
    describe ')' do
      include_examples 'component', 'an array without the first element', stack: [[1, 2, 3, 4]], result: [1, 2, 3]
    end
    describe '*' do
      include_examples 'component', 'the multiplication of two numbers', stack: [6, 8], result: 48
    end
    describe '+' do
      include_examples 'component', 'the addition of two numbers', stack: [7, 4], result: 11
    end
    describe ',' do
      it 'prints an object to standard output with newline' do
        expect($stdout).to receive(:puts).with('hello!')
        Ohm.new(',', stack: %w(hello!)).exec
      end
    end
    describe '-' do
      include_examples 'component', 'the subtraction of two numbers', stack: [5, 7], result: -2
    end
    describe '.' do
      include_examples 'component', 'a character literal', circuit: '.!', result: '!'
    end
    describe '/' do
      include_examples 'component', 'the division of two numbers', stack: [6, 5], result: 1.2
    end
    describe '0-9' do
      include_examples 'component', 'a number literal (as a string)', circuit: '123', result: '123'
    end
    describe ':' do
      include_examples 'component', 'executes the given block for each element in an array', stack: [0, [1, 2, 3, 4]], circuit: ':_+', result: 10
    end
    # describe ';' do
    #   include_examples 'component', 'TODO', stack: [], result: 'TODO'
    # end
    describe '<' do
      include_examples 'component', 'whether one number is less than another', stack: [4, 5], result: 1
    end
    describe '=' do
      it 'prints an object to standard output with newline without popping' do
        expect($stdout).to receive(:puts).with('foobar')
        ohm = Ohm.new('=', stack: %w(foobar)).exec
        expect(ohm.stack.last[0]).to eq('foobar')
      end
    end
    describe '>' do
      include_examples 'component', 'whether one number is greater than another', stack: [4, 5], result: 0
    end
    describe '?' do
      include_examples 'component', 'conditionally executes the given block', stack: [0, 1], circuit: '?1', result: '1'
    end
    describe '@' do
      include_examples 'component', 'the range from 1 to a number', stack: [6], result: [1, 2, 3, 4, 5, 6]
    end
    describe 'A' do
      include_examples 'component', 'the absolute value of a number', stack: [-6], result: 6
    end
    describe 'B' do
      include_examples 'component', 'converts a number from base 10 to an arbitrary base', stack: [31, 16], result: '1F'
    end
    describe 'C' do
      include_examples 'not implemented'
    end
    describe 'D' do
      it 'pushes an object twice' do
        expect(Ohm.new('D', stack: [1]).exec.stack).to eq([1, 1])
      end
    end
    describe 'E' do
      include_examples 'component', 'whether two objects are equal', stack: [3, 7], result: 0
    end
    describe 'F' do
      include_examples 'not implemented'
    end
    describe 'G' do
      include_examples 'component', 'the inclusive range between two numbers', stack: [4, 7], result: [4, 5, 6, 7]
    end
    describe 'H' do
      include_examples 'component', 'a string split on spaces', stack: ['unit testing is fun'], result: %w(unit testing is fun)
    end
    describe 'I' do
      it 'gets user input' do
        allow($stdin).to receive(:gets) {'test input'}
        expect(Ohm.new('I').exec.stack.last[0]).to eq('test input')
      end
    end
    describe 'J' do
      include_examples 'component', 'an array joined on empty string', stack: [%w(foo bar baz)], result: 'foobarbaz'
    end
    describe 'K' do
      include_examples 'component', 'the amount of times an element occurs in an array', stack: [[1, 2, 1, 1], 1], result: 3
    end
    # RSpec doesn't like :print for whatever reason
    # describe 'L' do
    #   it 'prints an object to standard output without newline' do
    #     expect($stdout).to receive(:print).with('hello!')
    #     Ohm.new('L', stack: %w(hello!)).exec
    #   end
    # end
    describe 'M' do
      it 'executes the given block a number of times' do
        expect(Ohm.new('M2+', stack: [0, 4]).exec.stack.last[0]).to eq(8)
      end
    end
    describe 'N' do
      include_examples 'component', 'whether two objects are not equal', stack: [5, 2], result: 1
    end
    describe 'O' do
      it 'removes the last element of the stack' do
        expect(Ohm.new('O', stack: [1, 2]).exec.stack).to eq([1])
      end
    end
    describe 'P' do
      include_examples 'component', 'all primes up to a number', stack: [20], result: [2, 3, 5, 7, 11, 13, 17, 19]
    end
    describe 'Q' do
      it 'reverses the stack' do
        expect(Ohm.new('Q', stack: [1, 2, 3]).exec.stack).to eq([3, 2, 1])
      end
    end
    describe 'R' do
      include_examples 'component', 'a string reversed', stack: %w(reverse), result: 'esrever'
    end
    describe 'S' do
      include_examples 'component', 'an array sorted', stack: [[2, 5, 3, 1]], result: [1, 2, 3, 5]
    end
    describe 'T' do
      include_examples 'not implemented'
    end
    describe 'U' do
      include_examples 'component', 'an array uniquified', stack: [[1, 2, 2, 4, 4]], result: [1, 2, 4]
    end
    describe 'V' do
      include_examples 'component', 'the divisors of an integer', stack: [12], result: [1, 2, 3, 4, 6, 12]
    end
    describe 'W' do
      include_examples 'component', 'the stack wrapped in an array', stack: [1, 2, 3], result: [1, 2, 3]
    end
    describe 'X' do
      include_examples 'component', 'the NOT of a boolean', stack: [0], result: 1
    end
    describe 'Y' do
      include_examples 'component', 'the proper divisors of a number', stack: [12], result: [1, 2, 3, 4, 6]
    end
    describe 'Z' do
      include_examples 'component', 'a string split on newlines', stack: ["unit\ntesting\nis\nfun"], result: %w(unit testing is fun)
    end
    describe '[' do
      include_examples 'component', 'the element of the stack at the given index', stack: [1, 2, 3, 4, 2], result: 3
    end
    describe '\\' do
      include_examples 'component', 'a string with occurrences of a string replaced with another string', stack: ['foobarbaz', 'ar', 'az'], result: 'foobazbaz'
    end
    describe ']' do
      it 'flattens an array onto the stack by one level' do
        expect(Ohm.new(']', stack: [[1, [2, 4]]]).exec.stack).to eq([1, [2, 4]])
      end
    end
    describe '^' do
      include_examples 'component', 'the current index', result: 2
    end
    describe '_' do
      include_examples 'component', 'the current value', result: 5
    end
    describe '`' do
      include_examples 'component', 'the char code of a character', stack: ['!'], result: 33
    end
    describe 'a' do
      include_examples 'component', 'the absolute difference of two numbers', stack: [2, 5], result: 3
    end
    describe 'b' do
      include_examples 'component', 'a number converted to binary', stack: [9], result: '1001'
    end
    describe 'c' do
      include_examples 'component', 'the nCr function of two numbers', stack: [7, 2], result: 21
    end
    describe 'd' do
      include_examples 'component', 'a number doubled', stack: [3.5], result: 7
    end
    describe 'e' do
      include_examples 'component', 'the nPr function of two numbers', stack: [5, 3], result: 60
    end
    describe 'f' do
      include_examples 'component', 'all Fibonacci numbers up to a number', stack: [60], result: [1, 1, 2, 3, 5, 8, 13, 21, 43, 55]
    end
    describe 'g' do
      include_examples 'component', 'the exclusive range between two numbers', stack: [4, 8], result: [4, 5, 6, 7]
    end
    describe 'h' do
      include_examples 'component', 'the first element of an array', stack: [[1, 2, 3]], result: 1
    end
    describe 'i' do
      include_examples 'component', 'the last element of an array', stack: [[1, 2, 3]], result: 3
    end
    describe 'j' do
      include_examples 'component', 'an array joined on a string', stack: [[1, 2, 3]], result: '1, 2, 3'
    end
    describe 'k' do
      include_examples 'component', 'the index of an object in an array', stack: [[1, 2, 3], 2], result: 1
    end
    describe 'l' do
      include_examples 'component', 'the length of a string or array', stack: %w(foobar), result: 6
    end
    describe 'm' do
      include_examples 'component', 'the prime factors of a number', stack: [63], result: [3, 7]
    end
    describe 'n' do
      include_examples 'component', 'the exponents of the prime factorization of a number', stack: [63], result: [2, 1]
    end
    describe 'o' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'p' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'q' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'r' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 's' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 't' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'u' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'v' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'w' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'x' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'y' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'z' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '{' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '|' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '}' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '~' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¶' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'β' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'γ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'δ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ε' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ζ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'η' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'θ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ι' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'κ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'λ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'μ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ν' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ξ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'π' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ρ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ς' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'σ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'τ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'φ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'χ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ψ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ω' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Γ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Δ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Θ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Π' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Σ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Φ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ψ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ω' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'À' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Á' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Â' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ã' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ä' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Å' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ā' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'È' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'É' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ê' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ë' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ì' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Í' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Î' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ï' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ò' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ó' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ô' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Õ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ö' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ø' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Œ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ù' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ú' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Û' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ü' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ç' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ð' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ñ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Ý' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'Þ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'à' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'á' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'â' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ã' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ä' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'å' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ā' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'æ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'è' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'é' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ê' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ë' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ì' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'í' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'î' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ï' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ò' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ó' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ô' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'õ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ö' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ø' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'œ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ù' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ú' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'û' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ü' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ç' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ð' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ñ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'ý' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe 'þ' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¿' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‽' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '⁇' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '⁈' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‼' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¡' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‰' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‱' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¦' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '§' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '©' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '®' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '±' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¬' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¢' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '¤' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '«' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '»' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‹' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '›' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '“' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '”' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‘' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '’' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '‥' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '…' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '᠁' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '∩' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '∪' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '⊂' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
    describe '⊃' do
      include_examples 'component', 'TODO', stack: [], result: 'TODO'
    end
  end
end
