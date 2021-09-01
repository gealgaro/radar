shared_examples 'a listable resource' do
  around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/list") { test.run } }

  it 'responds with an Array' do
    expect(described_class.all).to be_a(Array)
  end

  it "returns a list of #{described_class.name} objects" do
    expect(described_class.all.all? { |item| item.is_a?(described_class) }).to eq true
  end
end

shared_examples 'a listable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}/#{described_class.class_name.downcase}/list") do
      test.run
    end
  end

  it 'responds with an Array' do
    expect(described_class.list(params: params)).to be_a(Array)
  end

  it "returns a list of #{described_class.name} objects" do
    expect(described_class.list(params: params).all? { |item| item.is_a?(described_class) }).to eq true
  end
end
