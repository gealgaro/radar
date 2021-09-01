RSpec.describe Radar::User do
  it_behaves_like 'a radar resource'
  it_behaves_like 'a listable resource'
  it_behaves_like 'a retrievable resource' do
    let(:resource_id) { '612d41412b9c6200660a8feb' }
  end
  it_behaves_like 'a deletable resource' do
    let(:resource_id) { '612d41412b9c6200660a8feb' }
  end
end
