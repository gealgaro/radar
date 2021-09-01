RSpec.describe Radar::Event do
  it_behaves_like 'a radar resource'
  it_behaves_like 'a listable resource'
  it_behaves_like 'a retrievable resource' do
    let(:resource_id) { '612f4061001abc006317503f' }
  end
end
