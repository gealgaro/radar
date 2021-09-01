RSpec.describe Radar do
  let(:basic_resources) do
    %w[events geofences track trips users]
  end
  let(:nested_resources) { %w[] }
  let(:supported_resources) { (basic_resources + nested_resources).sort }

  it "has a version number" do
    expect(Radar::VERSION).not_to be nil
  end

  describe '#api_resources' do
    it 'returns a hash listing all supported resources sorted alphabetically by key' do
      expect(subject.api_resources.keys).to match_array supported_resources
    end
  end
end
