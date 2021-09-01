RSpec.describe Radar::API::Resource do
  describe '#api_client' do
    it 'returns an instance of Radar::API::Client' do
      expect(described_class.api_client).to be_a Radar::API::Client
    end
  end

  describe '#class_name' do
    it 'returns the class as a string excluding modules' do
      expect(described_class.class_name).to eq 'Resource'
    end
  end

  describe '#resource_base_path' do
    it 'raises an error if called on itself' do
      expect { described_class.resource_base_path }.to raise_error(NotImplementedError)
    end
  end

  describe '#descendants' do
    let(:known_resources) do
      [Radar::Event,
       Radar::Geofence,
       Radar::Track,
       Radar::Trip,
       Radar::User].freeze
    end

    it 'returns all classes that inherite from the current class' do
      expect(described_class.descendants).to match_array known_resources
    end
  end

  context 'Resource attributes' do
    let(:parsed_json) do
      {
        '_id' => '56db1f4613012711002229f4',
        'live' => true,
        'userId' => '1',
        'deviceId' => 'C305F2DB-56DC-404F-B6C1-BC52F0B680D8',
        'location' => {
          'type' => 'Point',
          'coordinates' => [-73.97536, 40.78382]
        },
        'locationAccuracy' => 5,
        'foreground' => true,
        'stopped' => true,
        'deviceType' => 'iOS',
        'updatedAt' => '2016-06-10T13:44:10.535Z'
      }
    end

    describe '#initialize' do

      it 'initialize a new object base on data passed as params using snake_case standard' do
        object = described_class.new(parsed_json)
        parsed_json.keys.each do |key|
          expect(object.respond_to?(key.to_snake_case)).to eq true
        end
      end
    end

    describe '#to_h' do
      it 'converts any resource object as a hash snake_case standard' do
        object = Radar::User.new(parsed_json)
        expect(object.to_h).to eq(
          '_id': '56db1f4613012711002229f4',
          'live': true,
          'user_id': '1',
          'device_id': 'C305F2DB-56DC-404F-B6C1-BC52F0B680D8',
          'location': {
            'type' => 'Point',
            'coordinates' => [-73.97536, 40.78382]
          },
          'location_accuracy': 5,
          'foreground': true,
          'stopped': true,
          'device_type': 'iOS',
          'updated_at': '2016-06-10T13:44:10.535Z'
        )
      end
    end
  end
end
