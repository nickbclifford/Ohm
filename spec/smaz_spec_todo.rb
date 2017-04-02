require_relative '../lib/smaz'

RSpec.describe Ohm::Smaz do
  let(:str) {'unit testing'}

  describe '#compress' do
    it 'compresses a string with Smaz and converts it to base 220' do
      expect(Ohm::Smaz.compress(str)).to eq("2c\u00E4\u2591\u00EF\u2320\u2557")
    end
  end

  describe '#decompress' do
    it 'obtains a string via base 220 and decompresses it with Smaz' do
      expect(Ohm::Smaz.decompress("2c\u00E4\u2591\u00EF\u2320\u2557")).to eq(str)
    end
  end

  describe '#compress_c' do
    it 'compresses a string with Smaz' do
      expect(Ohm::Smaz.compress_c(str)).to eq("\xE0/\x0E6JT".b)
    end
  end

  describe '#decompress_c' do
    it 'decompresses a string with Smaz' do
      expect(Ohm::Smaz.decompress_c("\xE0/\x0E6JT".b)).to eq(str)
    end
  end
end
