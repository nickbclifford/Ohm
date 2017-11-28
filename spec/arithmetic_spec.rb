RSpec.describe Ohm do
  describe 'arithmetic components' do
    describe 'Æ²' do
      include_examples 'component', 'whether the given number is a perfect square', '36Æ²', 1
    end
    describe 'Æⁿ' do
      include_examples 'component', 'whether the given number is a perfect power', '216 3Æⁿ', 1
    end
    describe 'Æ↑' do
      include_examples 'component', 'the greatest common divisor of two numbers', '27 69Æ↑', 3
    end
    describe 'Æ↓' do
      include_examples 'component', 'the least common multiple of two numbers', '27 69Æ↓', 621
    end
    describe 'Æ×' do
      include_examples 'component', 'the complex exponentiation of two numbers', '3 2 3~«Æ×3·¦', [-8.893, 1.383]
    end
    describe 'Æ*' do
      include_examples 'component', 'the complex multiplication of two numbers', '3~ 5«2 3~«Æ*', [9, 19]
    end
    describe 'Æ/' do
      include_examples 'component', 'the complex division of two numbers', '3~ 5«2 3~«Æ/3·¦', [-1.615, 0.077]
    end
    describe 'ÆC' do
      include_examples 'component', 'TODO', 'ÆC', 'TODO'
    end
    describe 'ÆD' do
      include_examples 'component', 'TODO', 'ÆD', 'TODO'
    end
    describe 'ÆE' do
      include_examples 'component', 'TODO', 'ÆE', 'TODO'
    end
    describe 'ÆH' do
      include_examples 'component', 'TODO', 'ÆH', 'TODO'
    end
    describe 'ÆL' do
      include_examples 'component', 'TODO', 'ÆL', 'TODO'
    end
    describe 'ÆM' do
      include_examples 'component', 'TODO', 'ÆM', 'TODO'
    end
    describe 'ÆN' do
      include_examples 'component', 'TODO', 'ÆN', 'TODO'
    end
    describe 'ÆS' do
      include_examples 'component', 'TODO', 'ÆS', 'TODO'
    end
    describe 'ÆT' do
      include_examples 'component', 'TODO', 'ÆT', 'TODO'
    end
    describe 'Æc' do
      include_examples 'component', 'TODO', 'Æc', 'TODO'
    end
    describe 'Æl' do
      include_examples 'component', 'TODO', 'Æl', 'TODO'
    end
    describe 'Æm' do
      include_examples 'component', 'TODO', 'Æm', 'TODO'
    end
    describe 'Æn' do
      include_examples 'component', 'TODO', 'Æn', 'TODO'
    end
    describe 'Æo' do
      include_examples 'component', 'TODO', 'Æo', 'TODO'
    end
    describe 'Æp' do
      include_examples 'component', 'TODO', 'Æp', 'TODO'
    end
    describe 'Æs' do
      include_examples 'component', 'TODO', 'Æs', 'TODO'
    end
    describe 'Æt' do
      include_examples 'component', 'TODO', 'Æt', 'TODO'
    end
    describe 'Æu' do
      include_examples 'component', 'TODO', 'Æu', 'TODO'
    end
    describe 'Æ¬' do
      include_examples 'component', 'TODO', 'Æ¬', 'TODO'
    end
    describe 'Æ¤' do
      include_examples 'component', 'TODO', 'Æ¤', 'TODO'
    end
    describe 'Æ«' do
      include_examples 'component', 'TODO', 'Æ«', 'TODO'
    end
    describe 'Æ»' do
      include_examples 'component', 'TODO', 'Æ»', 'TODO'
    end
  end
end
