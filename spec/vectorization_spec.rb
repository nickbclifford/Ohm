RSpec.describe Ohm do
  describe 'component vectorization' do
    include_examples 'component', 'a zero-depth monad vectorized over an array', "4@\u2265", [2, 3, 4, 5]
    include_examples 'component', 'a 1-depth monad vectorized over a 2D array', "2@W\u2310", [[[1, 2], [2, 1]]]
    include_examples 'component', 'a zero-depth dyad vectorized over two arrays', '3@2#+', [1, 3, 5]
    include_examples 'component', 'a 1-depth dyad vectorized over an array', "\"test\"3@\u00AA", %w(e s t)
  end
end
