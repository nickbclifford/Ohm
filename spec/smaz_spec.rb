require_relative '../lib/smaz'

RSpec.describe Ohm::Smaz do
  let(:str) {'unit testing'}

  describe '#compress' do
    it 'compresses a string with Smaz and converts it to base 255' do
      expect(Ohm::Smaz.compress(str)).to eq('‼ΣΦ⁼3‹')
    end
  end

  describe '#decompress' do
    it 'obtains a string via base 255 and decompresses it with Smaz' do
      expect(Ohm::Smaz.decompress('‼ΣΦ⁼3‹')).to eq(str)
    end
  end
end
