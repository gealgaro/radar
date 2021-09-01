RSpec.describe Radar::API::NestedResource do
  it { expect(described_class).to be < Radar::API::Resource }

  describe '#resource_base_path' do
    it 'raises an error if it calls on itself' do
      expect { described_class.resource_base_path }.to raise_error(NotImplementedError)
    end
  end
end
