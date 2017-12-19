RSpec.describe Ohm do
  describe 'components' do
    before(:each) do
      srand 1337
    end

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
      it 'conditionally executes the given block' do
        expect(Ohm.new('?1', stack: [0, 1]).exec.stack.last[0]).to eq('1')
      end
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
      include_examples 'component', 'all Fibonacci numbers up to a number', stack: [60], result: [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
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
      include_examples 'component', 'an array joined on a string', stack: [[1, 2, 3], ', '], result: '1, 2, 3'
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
      include_examples 'component', 'the full prime factorization of a number', stack: [63], result: [3, 3, 7]
    end
    describe 'p' do
      include_examples 'component', 'whether a number is prime', stack: [17], result: 1
    end
    describe 'q' do
      it 'immediately stops program execution' do
        expect(Ohm.new('0q1').exec.stack.last[0]).to eq('0')
      end
    end
    describe 'r' do
      include_examples 'component', 'a string with the given character transposed with another', stack: %w(foo o a), result: 'faa'
    end
    describe 's' do
      include_examples 'component', 'the top two elements of the stack swapped', stack: [1, 2, 3], result: 2
    end
    describe 't' do
      include_examples 'component', 'a number converted from the given base to base 10', stack: ['21', 16], result: 33
    end
    describe 'u' do
      include_examples 'component', 'an object converted to a string', stack: [5.6], result: '5.6'
    end
    describe 'v' do
      include_examples 'component', 'the integer division of two numbers', stack: [7, 3], result: 2
    end
    describe 'w' do
      include_examples 'component', 'an object wrapped in an array', stack: [5, 6], result: [6]
    end
    describe 'x' do
      include_examples 'component', 'a number converted to hexadecimal', stack: [33], result: '21'
    end
    describe 'y' do
      include_examples 'component', 'the sign of a number', stack: [-5], result: -1
    end
    describe 'z' do
      include_examples 'component', 'a string with surrounding whitespace trimmed off', stack: [' asdf '], result: 'asdf'
    end
    describe '{' do
      include_examples 'component', 'an array deep flattened', stack: [[1, [2, [3, 4]], 5]], result: [1, 2, 3, 4, 5]
    end
    describe '|' do
      include_examples 'component', 'the OR of two booleans', stack: [0, 1], result: 1
    end
    describe '}' do
      include_examples 'component', 'a string or array split into slices of length 1', stack: %w(foo), result: %w(f o o)
    end
    describe '~' do
      include_examples 'component', 'a number negated', stack: [1.5], result: -1.5
    end
    describe '¶' do
      it 'functions as a newline' do
        # I'm honestly not really sure what to do here, since top_level isn't public
        expect(Ohm.new('1¶2').exec.stack.last[0]).to eq('1')
      end
    end
    describe 'β' do
      include_examples 'component', 'an array split into a number of groups', stack: [[1, 2, 3, 4, 5, 6], 2], result: [[1, 2, 3], [4, 5, 6]]
    end
    describe 'γ' do
      include_examples 'component', 'all possible rotations of an array', stack: [[1, 2, 3]], result: [[1, 2, 3], [2, 3, 1], [3, 1, 2]]
    end
    describe 'δ' do
      include_examples 'component', 'the consecutive differences of an array', stack: [[1, 5, 3]], result: [4, -2]
    end
    describe 'ε' do
      include_examples 'component', 'whether an object is in an array or string', stack: %w(foobar foo), result: 1
    end
    describe 'ζ' do
      include_examples 'component', 'the first and last elements of an array', stack: [[1, 2, 3]], result: [1, 3]
    end
    describe 'η' do
      include_examples 'component', 'whether an object is empty', stack: [''], result: 1
    end
    describe 'θ' do
      include_examples 'component', 'an arbitrary slice of an array', stack: [[1, 2, 3, 4, 5], 1, 3], result: [2, 3, 4]
    end
    describe 'ι' do
      include_examples 'component', 'a slice from the beginning of an array', stack: [[1, 2, 3, 4, 5], 2], result: [1, 2, 3]
    end
    describe 'κ' do
      include_examples 'component', 'a slice from the end of an array', stack: [[1, 2, 3, 4, 5], 2], result: [3, 4, 5]
    end
    describe 'λ' do
      include_examples 'component', 'an array rotated once to the left', stack: [[1, 2, 3]], result: [2, 3, 1]
    end
    describe 'μ' do
      include_examples 'component', 'the Cartesian product of two arrays', stack: [[1, 2], [3, 4]], result: [[1, 3], [1, 4], [2, 3], [2, 4]]
    end
    describe 'ν' do
      include_examples 'component', 'whether an object is in an array or string (without vectorization)', stack: [[[1, 2], [3, 4]], [1, 2]], result: 1
    end
    describe 'ξ' do
      it 'pushes an object three times' do
        expect(Ohm.new('ξ', stack: [1]).exec.stack).to eq([1, 1, 1])
      end
    end
    describe 'π' do
      include_examples 'component', 'the prime number at a given index (1-based)', stack: [3], result: 5
    end
    describe 'ρ' do
      include_examples 'component', 'an array rotated once to the right', stack: [[1, 2, 3]], result: [3, 1, 2]
    end
    describe 'ς' do
      include_examples 'component', 'an array sorted by the results of running the given block', stack: [[1, -2]], circuit: 'ςy', result: [-2, 1]
    end
    describe 'σ' do
      include_examples 'component', 'an array split into groups of a given length', stack: [[1, 2, 3, 4, 5, 6], 2], result: [[1, 2], [3, 4], [5, 6]]
    end
    describe 'τ' do
      include_examples 'component', '10', result: 10
    end
    describe 'φ' do
      include_examples 'component', 'the totient function of a number', stack: [9], result: 6
    end
    describe 'χ' do
      include_examples 'component', 'the elements of an array that return the minimum and maximum value from the given block', stack: [%w(foo foobar foobarbaz)], circuit: 'χl', result: %w(foo foobarbaz)
    end
    describe 'ψ' do
      include_examples 'component', 'all permutations of an array', stack: [[1, 2, 3]], result: [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
    end
    describe 'ω' do
      include_examples 'component', 'the power set of an array', stack: [[1, 2]], result: [[], [1], [2], [1, 2]]
    end
    describe 'Γ' do
      include_examples 'component', '-1', result: -1
    end
    describe 'Δ' do
      include_examples 'component', 'the absolute consecutive differences of an array', stack: [[1, 5, 3]], result: [4, 2]
    end
    describe 'Θ' do
      it 'executes the previous wire' do
        expect(Ohm.new("1\nΘ", top_level: {wires: %w(1, Θ), index: 1}).exec.stack.last[0]).to eq('1')
      end
    end
    describe 'Π' do
      include_examples 'component', 'the total product of an array', stack: [[1, 2, 3]], result: 6
    end
    describe 'Σ' do
      include_examples 'component', 'the total sum of an array', stack: [[2, 3, 5]], result: 10
    end
    describe 'Φ' do
      it 'executes the wire at an index' do
        expect(Ohm.new("Φ\n1\n2", stack: [2]).exec.stack.last[0]).to eq('2')
      end
    end
    describe 'Ψ' do
      it 're-executes the current wire' do
        expect(Ohm.new('⁹X?⁺Ψ;1').exec.stack.last[0]).to eq('1')
      end
    end
    describe 'Ω' do
      it 'executes the next wire' do
        expect(Ohm.new("Ω\n1").exec.stack.last[0]).to eq('1')
      end
    end
    describe 'À' do
      include_examples 'component', 'a string in all lowercase', stack: %w(foOBar), result: 'foobar'
    end
    describe 'Á' do
      include_examples 'component', 'a string in all uppercase', stack: %w(foOBar), result: 'FOOBAR'
    end
    describe 'Â' do
      include_examples 'component', 'a string in titlecase', stack: ['foOBar baz'], result: 'Foobar Baz'
    end
    describe 'Ã' do
      include_examples 'component', 'a string with capitalization swapped', stack: %w(foOBar), result: 'FOobAR'
    end
    describe 'Ä' do
      it 'pushes an object a certain amount of times' do
        expect(Ohm.new('Ä', stack: [1, 5]).exec.stack).to eq([1, 1, 1, 1, 1])
      end
    end
    describe 'Å' do
      include_examples 'component', 'whether all the elements in an array return truthy from the block', stack: [[1, 3, 5]], circuit: 'Å2%', result: 1
    end
    describe 'Ā' do
      include_examples 'component', 'a string with the first letter capitalized', stack: ['foOBar baz'], result: 'Foobar baz'
    end
    describe 'È' do
      include_examples 'not implemented'
    end
    describe 'É' do
      include_examples 'component', 'whether any of the elements in an array return truthy from the block', stack: [[1, 2, 4]], circuit: 'É2%', result: 1
    end
    describe 'Ê' do
      include_examples 'not implemented'
    end
    describe 'Ë' do
      include_examples 'not implemented'
    end
    describe 'Ì' do
      include_examples 'not implemented'
    end
    describe 'Í' do
      include_examples 'not implemented'
    end
    describe 'Î' do
      include_examples 'not implemented'
    end
    describe 'Ï' do
      include_examples 'not implemented'
    end
    describe 'Ò' do
      include_examples 'not implemented'
    end
    describe 'Ó' do
      include_examples 'not implemented'
    end
    describe 'Ô' do
      include_examples 'not implemented'
    end
    describe 'Õ' do
      include_examples 'not implemented'
    end
    describe 'Ö' do
      include_examples 'component', 'the run-length encoding of a string', stack: %w(aaabcc), result: [['a', 3], ['b', 1], ['c', 2]]
    end
    describe 'Ø' do
      include_examples 'component', 'an array grouped by consecutive equal elements', stack: [[1, 3, 5, 3, 2, 2]], result: [[1], [3], [5], [3], [2, 2]]
    end
    describe 'Œ' do
      include_examples 'component', 'an array randomly shuffled', stack: [[1, 2, 3, 4, 5]], result: [4, 3, 2, 1, 5]
    end
    describe 'Ù' do
      include_examples 'component', 'a string with spaces appended', stack: ['foo', 2], result: 'foo  '
    end
    describe 'Ú' do
      include_examples 'component', 'a string with spaces prepended', stack: ['foo', 2], result: '  foo'
    end
    describe 'Û' do
      include_examples 'component', 'a string left-justified to a length with spaces', stack: ['foo', 6], result: 'foo   '
    end
    describe 'Ü' do
      include_examples 'component', 'a string right-justified to a length with spaces', stack: ['foo', 6], result: '   foo'
    end
    describe 'Ç' do
      include_examples 'component', 'every consecutive group of a certain length in an array', stack: [[1, 2, 3, 4], 2], result: [[1, 2], [2, 3], [3, 4]]
    end
    describe 'Ð' do
      include_examples 'component', 'a space character', result: ' '
    end
    describe 'Ñ' do
      include_examples 'component', 'a newline character', result: "\n"
    end
    describe 'Ý' do
      include_examples 'component', 'an empty string', result: ''
    end
    describe 'Þ' do
      include_examples 'component', 'an empty array', result: []
    end
    describe 'à' do
      include_examples 'component', 'the bitwise AND of two integers', stack: [7, 13], result: 5
    end
    describe 'á' do
      include_examples 'component', 'the bitwise OR of two integers', stack: [7, 13], result: 15
    end
    describe 'â' do
      include_examples 'component', 'the bitwise XOR of two integers', stack: [7, 13], result: 10
    end
    describe 'ã' do
      include_examples 'component', 'the bitwise NOT of an integer', stack: [7], result: -8
    end
    describe 'ä' do
      include_examples 'component', 'the prime factorization of an integer as an array of bases and exponents', stack: [63], result: [[3, 2], [7, 1]]
    end
    describe 'å' do
      include_examples 'not implemented'
    end
    describe 'ā' do
      include_examples 'not implemented'
    end
    describe 'æ' do
      include_examples 'component', 'a string palindromized', stack: %w(bar), result: 'barab'
    end
    describe 'è' do
      include_examples 'component', 'whether a number is odd', stack: [7], result: 1
    end
    describe 'é' do
      include_examples 'component', 'whether a number is even', stack: [6], result: 1
    end
    describe 'ê' do
      include_examples 'component', 'the Fibonacci numbers up to an index (1-based)', stack: [7], result: [1, 1, 2, 3, 5, 8, 13]
    end
    describe 'ë' do
      include_examples 'component', 'the prime numbers up to an index (1-based)', stack: [7], result: [2, 3, 5, 7, 11, 13, 17]
    end
    describe 'ì' do
      include_examples 'component', 'an object cast to an integer', stack: %w(7.8), result: 7
    end
    describe 'í' do
      include_examples 'component', 'an object cast to a float', stack: %w(1.5), result: 1.5
    end
    describe 'î' do
      include_examples 'component', 'whether a number is an integer', stack: %w(7.0), result: 1
    end
    describe 'ï' do
      include_examples 'component', 'a string split on a delimiter', stack: %w(foo,bar,baz ,), result: %w(foo bar baz)
    end
    describe 'ò' do
      include_examples 'component', 'an array zipped', stack: [[[1, 2], [3, 4]]], result: [[1, 3], [2, 4]]
    end
    describe 'ó' do
      include_examples 'component', 'a number converted from binary', stack: %w(1010), result: 10
    end
    describe 'ô' do
      include_examples 'component', 'a number converted from hexadecimal', stack: %w(FF), result: 255
    end
    describe 'õ' do
      include_examples 'not implemented'
    end
    describe 'ö' do
      include_examples 'component', 'the run-length decoding of an array', stack: [[['a', 3], ['b', 1], ['c', 2]]], result: 'aaabcc'
    end
    describe 'ø' do
      include_examples 'component', 'an array filled with an object a certain number of times', stack: [2, 4], result: [2, 2, 2, 2]
    end
    describe 'œ' do
      include_examples 'component', 'an object paired with its reverse', stack: %w(foobar), result: %w(foobar raboof)
    end
    describe 'ù' do
      include_examples 'component', 'an array joined on spaces', stack: %w(foo bar baz), result: 'foo bar baz'
    end
    describe 'ú' do
      include_examples 'component', 'an array joined on newlines', stack: %w(foo bar baz), result: "foo\nbar\nbaz"
    end
    describe 'û' do
      include_examples 'component', 'the range between two numbers with a certain step', stack: [1, 7, 2], result: [1, 3, 5, 7]
    end
    describe 'ü' do
      include_examples 'not implemented'
    end
    describe 'ç' do
      include_examples 'component', 'all possible combinations of a certain number of elements in an array', stack: [[1, 2, 3], 2], result: [[1, 2], [1, 3], [2, 3]]
    end
    describe 'ð' do
      include_examples 'component', 'whether a string is a palindrome', stack: %w(barab), result: 1
    end
    describe 'ñ' do
      include_examples 'component', 'whether a number is in the Fibonacci sequence', stack: [13], result: 1
    end
    describe 'ý' do
      include_examples 'component', 'the Fibonacci number at a given index (1-based)', stack: [7], result: 13
    end
    describe 'þ' do
      it 'sleeps execution for a given number of seconds' do
        expect(ohm = Ohm.new('þ', stack: [2])).to receive(:sleep).with(2)
        ohm.exec
      end
    end
    describe '¿' do
      it 'executes the given block if the condition given to `?` is false' do
        expect(Ohm.new('?1¿0', stack: [1, 0]).exec.stack.last[0]).to eq('0')
      end
    end
    describe '‽' do
      it 'conditionally breaks out of the current block' do
        expect(Ohm.new('2M⁹‽⁺;⁹').exec.stack.last[0]).to eq(1)
      end
    end
    describe '⁇' do
      include_examples 'component', 'an array filtered with the given block', stack: [[1, 2, 3, 4, 5]], circuit: '⁇è', result: [1, 3, 5]
    end
    describe '⁈' do
      include_examples 'component', 'an array partitioned by the given block', stack: [[1, 2, 3, 4, 5]], circuit: '⁈è', result: [[1, 3, 5], [2, 4]]
    end
    describe '‼' do
      include_examples 'component', 'an array filtered with false results from given block', stack: [[1, 2, 3, 4, 5]], circuit: '‼è', result: [2, 4]
    end
    describe '¡' do
      include_examples 'component', 'an array reduced over the given component', stack: [[1, 2, 3, 4, 5]], circuit: '¡-', result: -13
    end
    describe '‰' do
      include_examples 'component', '2 to the power of a number', stack: [4], result: 16
    end
    describe '‱' do
      include_examples 'component', '10 to the power of a number', stack: [4], result: 10000
    end
    describe '¦' do
      include_examples 'component', 'a number rounded to the nearest integers', stack: [2.7], result: 3
    end
    describe '§' do
      include_examples 'component', 'a random element from an array', stack: [[1, 2, 3, 4, 5]], result: 5
    end
    describe '©' do
      include_examples 'component', 'a string duplicated', stack: %w(foobar), result: 'foobarfoobar'
    end
    describe '®' do
      include_examples 'component', 'the element of an array at the given index', stack: [[1, 2, 3, 4], 2], result: 3
    end
    describe '±' do
      include_examples 'component', 'the nth root of a number', stack: [8, 3], result: 2
    end
    describe '¬' do
      include_examples 'component', 'the square root of a number', stack: [4], result: 2
    end
    describe '¢' do
      it 'sets the value of the register to an object' do
        expect(Ohm.new('¢', stack: [10]).exec.vars[:register]).to eq(10)
      end
    end
    describe '¤' do
      include_examples 'component', 'the intermediate results of an array reduced over the given component', stack: [[1, 2, 3, 4, 5]], circuit: '¤-', result: [1, -1, -4, -8, -13]
    end
    describe '«' do
      include_examples 'component', 'two objects paired', stack: [1, 2], result: [1, 2]
    end
    describe '»' do
      include_examples 'component', 'the result of applying the given component to an array', stack: [[1, 2, 3]], circuit: '»è', result: [1, 0, 1]
    end
    describe '‹' do
      include_examples 'component', 'a number decremented by 1', stack: [7], result: 6
    end
    describe '›' do
      include_examples 'component', 'a number incremented by 1', stack: [6], result: 7
    end
    describe '“' do
      include_examples 'component', 'a base-255 number literal', circuit: '“ζ+ó“', result: 8675309
    end
    describe '”' do
      include_examples 'component', 'a compressed string literal', circuit: '”‼ΣΦ⁼3‹”', result: 'unit testing'
    end
    describe '‘' do
      include_examples 'component', 'the element of an array that returns the minimum value from the given block', stack: [%w(foo foobar foobarbaz)], circuit: '‘l', result: 'foo'
    end
    describe '’' do
      include_examples 'component', 'the element of an array that returns the maximum value from the given block', stack: [%w(foo foobar foobarbaz)], circuit: '’l', result: 'foobarbaz'
    end
    describe '‥' do
      include_examples 'component', 'a two-character literal', circuit: '‥ab', result: 'ab'
    end
    describe '…' do
      include_examples 'component', 'a three-character literal', circuit: '…abc', result: 'abc'
    end
    describe '᠁' do
      include_examples 'component', 'a code page indexes literal', circuit: '᠁?¿᠁', result: [63, 224]
    end
    describe '∩' do
      include_examples 'component', 'the set intersection of two arrays', stack: [[1, 2, 3], [2, 3, 4]], result: [2, 3]
    end
    describe '∪' do
      include_examples 'component', 'the set union of two arrays', stack: [[1, 2, 3], [2, 3, 4]], result: [1, 2, 3, 4]
    end
    describe '⊂' do
      include_examples 'not implemented'
    end
    describe '⊃' do
      include_examples 'component', 'the set difference of two arrays', stack: [[1, 2, 3], [2, 3, 4]], result: [1]
    end
  end
end
