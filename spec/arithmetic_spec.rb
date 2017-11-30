RSpec.describe Ohm do
  describe 'arithmetic components' do
    describe 'Æ²' do
      include_examples 'component', 'whether the given number is a perfect square', stack: [36], result: 1
    end
    describe 'Æⁿ' do
      include_examples 'component', 'whether the given number is a perfect power', stack: [216, 3], result: 1
    end
    describe 'Æ↑' do
      include_examples 'component', 'the greatest common divisor of two numbers', stack: [27, 69], result: 3
    end
    describe 'Æ↓' do
      include_examples 'component', 'the least common multiple of two numbers', stack: [27, 69], result: 621
    end
    describe 'Æ×' do
      include_examples 'component', 'the complex exponentiation of two numbers', stack: [3, [2, -3]], result: [-8.89315134427972, 1.3826999557878903]
    end
    describe 'Æ*' do
      include_examples 'component', 'the complex multiplication of two numbers', stack: [[-3, 5], [2, -3]], result: [9, 19]
    end
    describe 'Æ/' do
      include_examples 'component', 'the complex division of two numbers', stack: [[-3, 5], [2, -3]], result: [-1.6153846153846154, 0.07692307692307676]
    end
    describe 'ÆC' do
      include_examples 'component', 'the cosine of a number in radians', stack: [0], result: 1
    end
    describe 'ÆD' do
      include_examples 'component', 'a number in radians converted to degrees', stack: [Math::PI], result: 180
    end
    describe 'ÆE' do
      include_examples 'component', 'a number in degrees converted to radians', stack: [180], result: Math::PI
    end
    describe 'ÆH' do
      include_examples 'component', 'the hypotenuse of a right triangle with the given sides', stack: [3, 4], result: 5
    end
    describe 'ÆL' do
      include_examples 'component', 'the natural logarithm of a number', stack: [Math::E], result: 1
    end
    describe 'ÆM' do
      include_examples 'component', 'the base 10 logarithm of a number', stack: [100], result: 2
    end
    describe 'ÆN' do
      include_examples 'component', 'the base 2 logarithm of a number', stack: [32], result: 5
    end
    describe 'ÆS' do
      include_examples 'component', 'the sine of a number in radians', stack: [Math::PI / 2], result: 1
    end
    describe 'ÆT' do
      include_examples 'component', 'the tangent of a number in radians', stack: [0], result: 0
    end
    describe 'Æc' do
      include_examples 'component', 'the arccosine of a number', stack: [1], result: 0
    end
    describe 'Æl' do
      include_examples 'component', 'the base-n logarithm of a number', stack: [5, 625], result: 4
    end
    describe 'Æm' do
      include_examples 'component', 'the arithmetic mean of an array of numbers', stack: [[2, 3, 4, 5]], result: 3.5
    end
    describe 'Æn' do
      include_examples 'component', 'the arithmetic median of an array of numbers', stack: [[3, 3, 5, 6, 6]], result: 5
    end
    describe 'Æo' do
      include_examples 'component', 'the arithmetic mode of an array of numbers', stack: [[1, 2, 2, 2, 3, 3]], result: [2]
    end
    describe 'Æp' do
      include_examples 'component', 'whether two numbers are coprime', stack: [12, 19], result: 1
    end
    describe 'Æs' do
      include_examples 'component', 'the arcsine of a number', stack: [1], result: Math::PI / 2
    end
    describe 'Æt' do
      include_examples 'component', 'the arctangent of a number', stack: [0], result: 0
    end
    describe 'Æu' do
      include_examples 'component', 'the arctangent of two numbers\' quotient (atan2)', stack: [1, 1], result: Math::PI / 4
    end
    describe 'Æ¬' do
      include_examples 'component', 'the complex square root of a number', stack: [-4], result: [0, 2]
    end
    describe 'Æ¤' do
      include_examples 'component', 'the n-gonal number at the given index', stack: [5, 8], result: 92
    end
    describe 'Æ«' do
      include_examples 'component', 'a number left bit-shifted the given amount of times', stack: [3, 5], result: 96
    end
    describe 'Æ»' do
      include_examples 'component', 'an number right bit-shifted the given amount of times', stack: [96, 3], result: 12
    end
  end
end
