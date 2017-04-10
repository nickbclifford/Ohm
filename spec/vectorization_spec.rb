RSpec.describe Ohm do
  describe 'component vectorization' do
    include_examples 'component', 'a zero-depth monad vectorized over an array', "4@\u2265", [2, 3, 4, 5]
    include_examples 'component', 'a 1-depth monad vectorized over a 2D array', "2#W\u2310", [[[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]]
    include_examples 'component', 'a zero-depth dyad vectorized over two arrays', "3@2#+", [1, 3, 5]
    include_examples 'component', 'a 1-depth dyad vectorized over an array', "\"test\"3@\u00AA", ['e', 's', 't']
  end
end
