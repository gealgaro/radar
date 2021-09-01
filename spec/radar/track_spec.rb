RSpec.describe Radar::Track do
  it_behaves_like 'a radar resource'
  it_behaves_like 'a creatable resource' do
    let(:params) {
      {
        device_id: 'some-random-device-id',
        user_id: 'maybe-some-random-uuid',
        latitude: 40.78382,
        longitude: -73.97536,
        accuracy: 70,
        foreground: false,
        stopped: true,
        description: 'Test user created from tests',
        device_type: 'iOS'
      }
    }
    let(:result_attrs) {
      {
        _id:              '612d41412b9c6200660a8feb',
        deviceId:         'some-random-device-id',
        userId:           'maybe-some-random-uuid',
        location:         { 'type' => 'Point', 'coordinates' => [-73.97536, 40.78382] },
        locationAccuracy: 70,
        foreground:       false,
        stopped:          true,
        description:      'Test user created from tests',
        deviceType:       'iOS',
        geofences:        []
      }
    }
  end
end
