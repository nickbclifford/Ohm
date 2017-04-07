require_relative '../ohm'

RSpec.shared_examples 'component' do |desc, circuit, result|
  it "pushes #{desc}" do
    expect(Ohm.new(circuit, false).exec.stack.last[0]).to eq(result)
  end
end

RSpec.describe Ohm do
  describe '!' do
    include_examples 'component', 'the factorial of a number', '5!', 120
  end

  describe '"' do
    include_examples 'component', 'a string literal', '"asdf', 'asdf'
  end

  describe '#' do
    include_examples 'component', 'the inclusive range of integers between 0 and a number', '5~#', [0, -1, -2, -3, -4, -5]
  end

  describe '$' do
    include_examples 'component', 'the current value of the register (default 1)', '$', 1
  end

  describe '%' do
    include_examples 'component', 'the modulo of two numbers', '8 5%', 3
  end

  describe '&' do
    include_examples 'component', 'a boolean AND another boolean', 'TF&', false
  end

  describe '\'' do
    include_examples 'component', 'a number converted to the character with the corresponding char code', '65\'', 'A'
  end

  describe '(' do
    include_examples 'component', 'an array or string without the first element', '"unit test"(', 'nit test'
  end

  describe ')' do
    include_examples 'component', 'an array or string without the last element', '"unit test")', 'unit tes'
  end

  describe '*' do
    include_examples 'component', 'the product of two numbers', '4 3*', 12
  end

  describe '+' do
    include_examples 'component', 'the sum of two numbers', '5 8+', 13
  end

  describe ',' do
    it 'prints to standard output with a trailing newline' do
      expect($stdout).to receive(:puts).with('10')
      Ohm.new('10,', false).exec
    end
  end

  describe '-' do
    include_examples 'component', 'the difference of two numbers', '5 3-', 2
  end

  describe '.' do
    include_examples 'component', 'a character literal', '.a', 'a'
  end

  describe '/' do
    include_examples 'component', 'the quotient of two numbers', '6 3/', 2
  end

  describe '<' do
    include_examples 'component', 'whether one number is less than another', '5 8<', true
  end

  describe '=' do
    it 'prints to standard output with a trailing newline without popping' do
      expect($stdout).to receive(:puts).with('10')
      circuit = Ohm.new('10=', false).exec
      expect(circuit.stack.last[0]).to eq('10')
    end
  end

  describe '>' do
    include_examples 'component', 'whether one number is greater than another', '9 2>', true
  end

  describe '?' do
    it 'conditionally executes a block of code' do
      expect(Ohm.new('T?8 1+', false).exec.stack.last[0]).to eq(9)
    end
  end

  describe '@' do
    include_examples 'component', 'the inclusive range of integers between 1 and a number', '5@', (1..5).to_a
  end

  describe 'A' do
    include_examples 'component', 'the absolute value of a number', '9~A', 9
  end

  describe 'B' do
    include_examples 'component', 'a number converted to an arbitrary base', '8 3B', '22'
  end

  describe 'C' do
    include_examples 'component', 'an array or string concatenated with another', '2#3@C', [0, 1, 2, 1, 2, 3]
  end

  describe 'D' do
    it 'duplicates the top of the stack' do
      expect(Ohm.new('2D', false).exec.stack).to eq(['2', '2'])
    end
  end

  describe 'E' do
    include_examples 'component', 'whether two items are equal', '5DE', true
  end

  describe 'F' do
    include_examples 'component', 'false', 'F', false
  end

  describe 'G' do
    include_examples 'component', 'the inclusive range of integers between two numbers', '2 9G', (2..9).to_a
  end

  describe 'H' do
    include_examples 'component', 'an array with an item pushed to it', '2#5H', [0, 1, 2, '5']
  end

  describe 'I' do
    it 'pushes user input' do
      allow($stdin).to receive(:gets) {'a'}
      expect(Ohm.new('I', false).exec.stack.last[0]).to eq('a')
    end
  end

  describe 'J' do
    include_examples 'component', 'an array joined into a string', '5#J', '012345'
  end

  describe 'K' do
    include_examples 'component', 'the amount of times an item appears in an array or string', '"unit testing is fun".iK', 3
  end

  # Alright so it looks to me like RSpec can't really tell the difference between `puts` and `print`
  # I'm going to skip this spec
  # describe 'L' do
  # end
  
  describe 'M' do
    it 'executes a block of code a number of times' do
      expect(Ohm.new('3DM8+', false).exec.stack.last[0]).to eq(27)
    end
  end

  describe 'N' do
    include_examples 'component', 'whether two items are inequal', '5 1N', true
  end

  describe 'O' do
    it 'removes the last item of the stack' do
      expect(Ohm.new('5 2 3 4O', false).exec.stack).to eq(['5', '2', '3'])
    end
  end

  describe 'P' do
    include_examples 'component', 'all primes up to a number', '9P', [2, 3, 5, 7]
  end

  describe 'Q' do
    it 'reverses the stack' do
      expect(Ohm.new('5 2 3 4Q', false).exec.stack).to eq(['4', '3', '2', '5'])
    end
  end

  describe 'R' do
    include_examples 'component', 'an array or string reversed', '"unit"R', 'tinu'
  end

  describe 'S' do
    include_examples 'component', 'an array or string sorted', '"unit"S', 'intu'
  end

  describe 'T' do
    include_examples 'component', 'true', 'T', true
  end

  describe 'U' do
    include_examples 'component', 'an array or string uniquified', '"testingisfun"U', 'tesingfu'
  end

  describe 'V' do
    include_examples 'component', 'all the divisors of a number', '24V', [1, 2, 3, 4, 6, 8, 12, 24]
  end

  describe 'W' do
    include_examples 'component', 'the whole stack wrapped as an array', '5 1 2 4 2W', ['5', '1', '2', '4', '2']
  end

  describe 'X' do
    include_examples 'component', 'an item prepended to an array or string', '"unit testing""foo"X', 'foounit testing'
  end

  describe 'Y' do
    include_examples 'component', 'all the proper divisors of a number', '24Y', [1, 2, 3, 4, 6, 8, 12]
  end

  describe 'Z' do
    include_examples 'component', 'a string split on newlines', '"unitÑtest"Z', ['unit', 'test']
  end

  describe '[' do
    include_examples 'component', 'the element of the stack at an index', '9 8 7 2 1[', '8'
  end

  describe '\\' do
    include_examples 'component', 'NOT a boolean', 'T\\', false
  end

  describe ']' do
    it 'flattens an array by one level onto the stack' do
      expect(Ohm.new('5@2@H]', false).exec.stack).to eq([1, 2, 3, 4, 5, 1, 2])
    end
  end

  describe '^' do
    include_examples 'component', 'the index being looped (default 2)', '2M^;W', [0, 1]
  end

  describe '_' do
    include_examples 'component', 'the element being looped (default 5)', '2@:_;W', [1, 2]
  end

  describe '`' do
    include_examples 'component', 'the char code or array of char codes from a string', '.a`', 97
  end

  describe 'a' do
    it 'swaps the top two elements of the stack' do
      expect(Ohm.new('3 5a', false).exec.stack).to eq(['5', '3'])
    end
  end

  describe 'b' do
    include_examples 'component', 'a number converted to binary', '31b', '11111'
  end

  describe 'c' do
    include_examples 'component', 'the binomial coefficient of two numbers (nCr)', '5 3c', 10
  end

  describe 'd' do
    include_examples 'component', 'a number doubled', '5d', 10
  end

  describe 'e' do
    include_examples 'component', 'the number of permutations of two numbers (nPr)', '5 3e', 60
  end

  describe 'f' do
    include_examples 'component', 'all Fibonacci numbers up to a number', '13f', [1, 1, 2, 3, 5, 8, 13]
  end

  describe 'g' do
    include_examples 'component', 'the range of integers between two numbers, exclusive to the second', '2 9g', (2...9).to_a
  end

  describe 'h' do
    include_examples 'component', 'the first element of an item', '"unit"h', 'u'
  end

  describe 'i' do
    include_examples 'component', 'the last element of an item', '"unit"i', 't'
  end

  describe 'j' do
    include_examples 'component', 'an array joined into a string with another string as a delimiter', '5#.aj', '0a1a2a3a4a5'
  end

  describe 'k' do
    include_examples 'component', 'the index of an item in an array', '1 3 4W3k', 1
  end

  describe 'l' do
    include_examples 'component', 'the length of an item', '"unit test"l', 9
  end

  describe 'm' do
    include_examples 'component', 'the prime factors of a number', '24m', [2, 3]
  end

  describe 'n' do
    include_examples 'component', 'the exponents of the prime factorization of a number', '24n', [3, 1]
  end

  describe 'o' do
    include_examples 'component', 'the prime factorization of a number', '24o', [[2, 3], [3, 1]]
  end

  describe 'p' do
    include_examples 'component', 'whether a number is prime', '9p', false
  end

  describe 'r' do
    include_examples 'component', 'the transposition of three strings', '"unit testing""ti""yo"r', 'unoy yesyong'
  end

  describe 's' do
    include_examples 'component', 'the string representation of an item', '3ds', '6'
  end

  describe 't' do
    include_examples 'component', 'the base 10 representation of a number in another base', '323 4t', 59
  end

  describe 'u' do
    include_examples 'component', 'the first occurrence of a subarray in an array', '9@2 3Gu', 2
  end

  describe 'v' do
    include_examples 'component', 'the floor division of two numbers', '9 2v', 4
  end

  describe 'w' do
    include_examples 'component', 'an item wrapped in an array', '5w', ['5']
  end

  describe 'x' do
    include_examples 'component', 'a number converted to hexadecimal', '28x', '1C'
  end

  describe 'y' do
    include_examples 'component', 'the sign of a number', '2~y', -1
  end

  describe 'z' do
    include_examples 'component', 'a string split on spaces', '"unit tests"z', ['unit', 'tests']
  end

  describe '{' do
    it 'deep flattens an array onto the stack' do
      expect(Ohm.new('4@w5@W{', false).exec.stack).to eq([1, 2, 3, 4, 1, 2, 3, 4, 5])
    end
  end

  describe '|' do
    include_examples 'component', 'a boolean OR another boolean', 'TF|', true
  end

  describe '}' do
    include_examples 'component', 'an item split into single elements', '"unit"}', ['u', 'n', 'i', 't']
  end

  describe '~' do
    include_examples 'component', 'a number negated', '5~', -5
  end

  describe "\u00C7" do
    include_examples 'component', 'an array of all the consecutive groups of (a number) elements in an item', "3@2\u00C7", [[1, 2], [2, 3]]
  end

  describe "\u00FC" do
    include_examples 'component', 'a space character', "\u00FC", ' '
  end

  describe "\u00E9" do
    include_examples 'component', 'whether a number is even', "4\u00E9", true
  end

  describe "\u00E2" do
    include_examples 'component', 'the first (a number) prime numbers', "4\u00E2", [2, 3, 5, 7]
  end

  describe "\u00E7" do
    include_examples 'component', 'an array of all possible combinations of a certain length of the elements in an array', "4@2\u00E7", [[1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]]
  end

  describe "\u00EA" do
    include_examples 'component', 'the first (a number) Fibonacci numbers', "4\u00EA", [1, 1, 2, 3]
  end

  describe "\u00E8" do
    include_examples 'component', 'whether a number is odd', "4\u00E8", false
  end

  describe "\u00EF" do
    include_examples 'component', 'a string split on another string', "\"unit testing\".i\u00EF", ['un', 't test', 'ng']
  end

  describe "\u00EE" do
    include_examples 'component', 'the integer representation of an item', "9 2/\u00EE", 4
  end

  describe "\u00EC" do
    include_examples 'component', 'whether an item is an integer', "9 2/\u00EC", false
  end

  describe "\u00C4" do
    it 'pushes an item on the stack a certain number of times' do
      expect(Ohm.new("3 5\u00C4", false).exec.stack).to eq(['3', '3', '3', '3', '3'])
    end
  end

  describe "\u00E6" do
    include_examples 'component', 'an item palindromized', "\"asdf\"\u00E6", 'asdfdsa'
  end

  describe "\u00F4" do
    include_examples 'component', 'the float representation of an item', "9\u00F4", 9.0
  end

  describe "\u00F6" do
    include_examples 'component', 'whether an item is not zero', "9\u00F6", true
  end

  describe "\u00FB" do
    include_examples 'component', 'the range between two numbers in steps of another number', "2 8 2\u00FB", [2, 4, 6, 8]
  end

  describe "\u00FF" do
    include_examples 'component', 'an empty string', "\u00FF", ''
  end

  describe "\u00D6" do
    include_examples 'component', 'whether an item is zero', "0\u00D6", true
  end

  describe "\u00DC" do
    include_examples 'component', 'the union of two arrays', "2#3@\u00DC", [0, 1, 2, 3]
  end

  describe "\u00A2" do
    it 'sets the register value to an item and keeps it on the stack' do
      ohm = Ohm.new("5\u00A2", false).exec
      expect(ohm.stack.last[0]).to eq('5')
      expect(ohm.vars[:register]).to eq('5')
    end
  end

  describe "\u00A3" do
    it 'sleeps execution for a certain number of seconds' do
      ohm = Ohm.new("1\u00A3", false)
      expect(ohm).to receive(:sleep)
      expect(ohm.exec.stack[0]).to be_nil
    end
  end

  describe "\u00A5" do
    include_examples 'component', 'whether an number is divisible by another', "24 3\u00A5", true
  end

  describe "\u00D6" do
    include_examples 'component', 'whether an item is zero', "0\u00D6", true
  end

  describe "\u20A7" do
    include_examples 'component', 'whether an item is a palindrome', "\"blah\"\u20A7", false
  end

  describe "\u0192" do
    include_examples 'component', 'the Fibonacci number at an index, 1-indexed', "4\u0192", 3
  end

  describe "\u00ED" do
    include_examples 'component', 'an array zipped', "9@3\u03C3\u00ED", [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  end

  describe "\u00F3" do
    include_examples 'component', 'a number converted from binary to base 10', "1101\u00F3", 13
  end

  describe "\u00FA" do
    include_examples 'component', 'a number converted from hexadecimal to base 10', "\"1E\"\u00FA", 30
  end

  describe "\u00F1" do
    include_examples 'component', 'whether a number is a Fibonacci number', "13\u00F1", true
  end

  describe "\u00D1" do
    include_examples 'component', 'a newline', "\u00D1", "\n"
  end
end
