RSpec.describe Ohm do
  describe 'extra components' do
    describe '·/' do
      include_examples 'component', 'the match and captures of a regex against a string', stack: %w(2016-04-20 (\d{4})-(\d{2})-(\d{2})), result: %w(2016-04-20 2016 04 20)
    end
    describe '·\\' do
      include_examples 'component', 'the diagonals of a matrix', stack: [[[1, 2, 3], [4, 5, 6], [7, 8, 9]]], result: [[1, 5, 9], [2, 6], [3], [7], [4, 8]]
    end
    describe '·G' do
      include_examples 'component', 'the respone of sending a GET request to a URL', stack: %w(https://gist.githubusercontent.com/RikerW/15dafb260c0d0293fb550a15e3151ffe/raw/5e80b85f33343398c433711aea81ee78cb5cdf93/gistfile1.txt), result: 'test'
    end
    describe '·c' do
      include_examples 'component', 'a string compressed', stack: %w(test), result: '⁷σ'
    end
    describe '·d' do
      include_examples 'component', 'a string decompressed', stack: %w(⁷σ), result: 'test'
    end
    describe '·e' do
      it 'executes a string as Ohm code' do
        expect(Ohm.new('·e', stack: %w(1 2+)).exec.stack.last[0]).to eq(3)
      end
    end
    describe '·p' do
      include_examples 'component', 'all prefixes of a string', stack: %w(test), result: %w(t te tes test)
    end
    describe '·r' do
      include_examples 'component', 'a random float between 0 and 1', result: 0.2620246750155817
    end
    describe '·s' do
      include_examples 'component', 'all suffixes of a string', stack: %w(test), result: %w(t st est test)
    end
    describe '·w' do
      include_examples 'component', 'the index of the first occurrence of a subarray in an array', stack: [[1, 2, 3, 4, 5, 6], [3, 4]], result: 2
    end
    describe '·~' do
      include_examples 'component', 'the index of the first match of a regex against a string', stack: %w(foobar (.)\1), result: 1
    end
    describe '·ψ' do
      include_examples 'component', 'whether two arrays are permutations of each other', stack: [[1, 2, 3], [3, 1, 2]], result: 1
    end
    describe '·Θ' do
      include_examples 'component', 'the last result given by evaluating the given block until the result has already been seen, using an object as the initial value', stack: [20], circuit: '·Θ}»²Σ', result: 42
    end
    describe '·Ω' do
      include_examples 'component', 'all results given by evaluating the given block until the result has already been seen, using an object as the initial value', stack: [20], circuit: '·Ω}»²Σ', result: [20, 4, 16, 37, 58, 89, 145, 42]
    end
    describe '·Ø' do
      include_examples 'component', 'the indices of an array grouped together by equal values', stack: [[1, 3, 5, 3, 2, 2]], result: [[0], [1, 3], [2], [4, 5]]
    end
    describe '·¦' do
      include_examples 'component', 'a number rounded to a certain number of decimal places', stack: [5.34262, 3], result: 5.343
    end
  end
end
