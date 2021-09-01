shared_examples 'a deletable resource' do
  around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/delete") { test.run } }

  it 'returns a boolean as the response' do
    expect(described_class.delete(id: resource_id)).to be_a Net::HTTPOK
  end
end
