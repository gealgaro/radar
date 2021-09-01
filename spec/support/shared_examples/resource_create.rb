shared_examples 'a creatable resource' do
  around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/create") { test.run } }

  it "returns the created #{described_class.name} object" do
    result = described_class.create(params: params)
    if result.is_a?(Array)
      expect(result.all? { |item| item.is_a?(described_class) }).to eq true
    else
      expect(result).to be_a described_class
    end
  end

  it 'matches the informations sent' do
    created_object = described_class.create(params: params)
    (result_attrs || params).keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq (result_attrs || params)[key] }
  end
end

shared_examples 'a creatable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}/#{described_class.class_name.downcase}/create") do
      test.run
    end
  end

  it "returns the created #{described_class.name} object" do
    result = described_class.create(params: params)
    if result.is_a?(Array)
      expect(result.all? { |item| item.is_a?(described_class) }).to eq true
    else
      expect(result).to be_a described_class
    end
  end
end
