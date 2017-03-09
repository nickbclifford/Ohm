require_relative '../ohm'

RSpec.describe Ohm::Stack do
  let(:ohm) {Ohm.new('5+', false)}

  describe '#pop, #last' do
    it 'gets additional user input if there are not enough elements' do
      allow($stdin).to receive(:gets) {'6'}
      expect(ohm.exec.stack.last[0]).to eq 11
    end
  end
end
