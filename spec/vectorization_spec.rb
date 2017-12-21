RSpec.describe Ohm do
  describe 'component vectorization' do
    describe '²' do
      include_examples 'component', 'a zero-depth monad vectorized over an array', stack: [[1, 2, 3]], result: [1, 4, 9]
    end
    describe '(' do
      include_examples 'component', 'a 1-depth monad vectorized over a 2D array', stack: [[[1, 2, 3], [4, 5], [6, 7, 8, 9]]], result: [[2, 3], [5], [7, 8, 9]]
    end
    describe '+' do
      include_examples 'component', 'a zero-depth dyad vectorized over two arrays', stack: [[1, 2, 3], [4, 5, 6]], result: [5, 7, 9]
    end
    describe 'j' do
      include_examples 'component', 'a 1-depth dyad vectorized over an array', stack: [[[1, 2, 3], [4, 5, 6]], ','], result: %w(1,2,3 4,5,6)
    end
  end
end
