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

  describe '#' do
    include_examples 'component', 'the inclusive range of integers between 0 and a number', '5#', (0..5).to_a
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
      expect(Ohm.new('I', false).exec.stack.last[0]).to eq 'a'
    end
  end

  describe 'H' do
    include_examples 'component', 'an array joined into a string', '5#J', '012345'
  end
end
