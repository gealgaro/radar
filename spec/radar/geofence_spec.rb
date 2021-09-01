RSpec.describe Radar::Geofence do
  it_behaves_like 'a radar resource'
  it_behaves_like 'a listable resource'
  it_behaves_like 'a retrievable resource' do
    let(:resource_id) { '611eb154d7e43c0040fa2283' }
  end

  context 'upserting geofences' do
    let(:tag) { 'Geofences-testing-suite' }
    let(:external_id) { 123454321 }
    let(:params) {
      {
        description: 'Geofence description from test suite',
        type: 'isochrone',
        coordinates: "[122.641452, 45.512118]",
        mode: 'car',
        radius: '60',
        enabled: 'true'
      }
    }
    let(:result_attrs) {
      {
        _id: '612f4592d72bb3002c984444',
        description: 'Geofence description from test suite',
        type: 'isochrone',
        geometryCenter: { 'coordinates' => [122.641452,45.512118], 'type' => 'Point'},
        geometryRadius: 60,
        mode: 'car',
        enabled: true
      }
    }

    describe '#create' do
      around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/create") { test.run } }

      it "returns the created #{described_class.name} object" do
        result = described_class.upsert(tag: tag, external_id: external_id, params: params)
        expect(result).to be_a described_class
      end

      it 'matches the informations sent' do
        created_object = described_class.upsert(tag: tag, external_id: external_id, params: params)
        result_attrs.keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq result_attrs[key] }
      end
    end

    describe '#update' do
      before do
        params[:radius] = 30
        params[:enabled] = false
        result_attrs[:geometryRadius] = 30
        result_attrs[:enabled] = false
      end

      around { |test| VCR.use_cassette("#{described_class.class_name.downcase}/update") { test.run } }

      it "returns the created #{described_class.name} object" do
        result = described_class.upsert(tag: tag, external_id: external_id, params: params)
        expect(result).to be_a described_class
      end

      it 'matches the informations sent' do
        created_object = described_class.upsert(tag: tag, external_id: external_id, params: params)
        result_attrs.keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq result_attrs[key] }
      end
    end
  end

  it_behaves_like 'a deletable resource' do
    let(:resource_id) { '611eb154d7e43c0040fa2283' }
  end
end
