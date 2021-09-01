shared_examples 'an updatable resource' do
  around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/update") { test.run } }

  it "returns the updated #{described_class.name} object" do
    updated_object = described_class.update(id: resource_id, params: params)
    expect(updated_object).to be_a described_class
    expect(updated_object._id).to eq resource_id
  end

  it 'matches the informations sent' do
    updated_object = described_class.update(id: resource_id, params: params)
    (result_attrs || params).keys.each { |key| expect(updated_object.send(key.to_s.to_snake_case)).to eq (result_attrs || params)[key] }
  end
end

shared_examples 'an updatable nested resource' do
  around do |test|
    VCR.use_cassette("#{described_class::PARENT_CLASS::RESOURCE_NAME}/#{described_class.class_name.downcase}/update") do
      test.run
    end
  end

  it "returns the updated #{described_class.name} object" do
    updated_object = described_class.update(id: resource_id, params: params)
    expect(updated_object).to be_a described_class
    expect(updated_object._id).to eq resource_id
  end

  it 'matches the informations sent' do
    updated_object = described_class.update(id: resource_id, params: params)
    params.keys.each { |key| expect(updated_object.send(key.to_s.to_snake_case)).to eq params[key] }
  end
end
