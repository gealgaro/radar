RSpec.describe Radar::Trip do
  it_behaves_like 'a radar resource'
  it_behaves_like 'a listable resource'

  context 'can be started by creating a new track' do
    let(:params) {
      {
        device_id: 'device-to-start-a-trip',
        user_id: 'user-uuid-starting-the-trip',
        latitude: 31.78382,
        longitude: -75.97536,
        accuracy: 80,
        foreground: false,
        stopped: true,
        description: 'Starting a new trip for a user created via tests',
        tripOptions: {
          mode: 'car',
          externalId: '12345'
        }
      }
    }
    let(:result_attrs) {
      {
        _id:              '612f398a0535f300790725c2',
        deviceId:         'device-to-start-a-trip',
        userId:           'user-uuid-starting-the-trip',
        location:         { 'type' => 'Point', 'coordinates' => [-75.97536, 31.78382] },
        locationAccuracy: 80,
        foreground:       false,
        stopped:          true,
        description:      'Starting a new trip for a user created via tests',
        geofences:        []
      }
    }

    around { |test| VCR.use_cassette("trip/start") { test.run } }

    it "returns a newly created Radar::Track object" do
      result = described_class.start(params: params)
      expect(result).to be_a Radar::Track
    end

    it 'matches the informations sent' do
      created_object = described_class.start(params: params)
      (result_attrs || params).keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq (result_attrs || params)[key] }
    end
  end

  context 'can be restarted' do
    let(:result_attrs) {
      {
        _id:          '612f3d41c276cf00802c863f',
        externalId:   '12345',
        mode:         'car',
        status:       'started',
        user:         { "_id" => "612f398a0535f300790725c2" }
      }
    }

    around { |test| VCR.use_cassette("trip/restart") { test.run } }

    it "returns the created #{described_class.name} object" do
      result = described_class.restart(id: '612f3d41c276cf00802c863f')
      expect(result).to be_a Radar::Trip
    end

    it 'matches the informations sent' do
      created_object = described_class.restart(id: '612f3d41c276cf00802c863f')
      (result_attrs || params).keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq (result_attrs || params)[key] }
    end
  end

  context 'can be stopped' do
    let(:result_attrs) {
      {
        _id:          '612f3d41c276cf00802c863f',
        externalId:   '12345',
        mode:         'car',
        status:       'canceled',
        user:         { "_id" => "612f398a0535f300790725c2" }
      }
    }

    around { |test| VCR.use_cassette("trip/stop") { test.run } }

    it "returns the created #{described_class.name} object" do
      result = described_class.stop(id: '612f3d41c276cf00802c863f')
      expect(result).to be_a Radar::Trip
    end

    it 'matches the informations sent' do
      created_object = described_class.stop(id: '612f3d41c276cf00802c863f')
      (result_attrs || params).keys.each { |key| expect(created_object.send(key.to_s.to_snake_case)).to eq (result_attrs || params)[key] }
    end
  end
end
