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

  describe '%' do
    include_examples 'component', 'the modulo of two numbers', '8 5%', 3
  end

  describe '*' do
    include_examples 'component', 'the product of two numbers', '4 3*', 12
  end

  describe '+' do
    include_examples 'component', 'the sum of two numbers', '5 8+', 13
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

  describe '>' do
    include_examples 'component', 'whether one number is greater than another', '9 2>', true
  end

  describe 'A' do
    include_examples 'component', 'the absolute value of a number', '9~A', 9
  end
end
