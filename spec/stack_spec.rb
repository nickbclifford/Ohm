RSpec.describe Ohm::Stack do
  describe '#pop, #last' do
    it 'gets additional user input if there are not enough elements' do
      expect(Ohm.new('5+', inputs: ['6']).exec.stack.last[0]).to eq 11
    end
  end
end
