RSpec.describe Radar::API::Client do
  SUPPORTED_HTTP_VERBS = %i[get post put patch delete].freeze

  context 'constants' do
    describe 'VERB_MAP' do
      it('is defined') { expect(described_class.const_defined?('VERB_MAP')).to eq true }
      it { expect(described_class::VERB_MAP.keys).to match_array(SUPPORTED_HTTP_VERBS) }
    end
  end

  describe '#initialize' do
    it 'defines http client instance' do
      expect(subject.http).to be_a Net::HTTP
    end
  end

  shared_examples 'a request made over http' do
    let(:stubbed_request) { stub_request(method_used, "https://#{Radar.api_host}#{endpoint}") }

    before do
      stubbed_request
      request
    end

    it { expect(stubbed_request).to have_been_requested }
  end

  context 'requests' do
    let(:endpoint) { '/test' }

    SUPPORTED_HTTP_VERBS.each do |method|
      describe "using `#{method.upcase}` method" do
        it_behaves_like 'a request made over http' do
          let(:method_used) { method }
          let(:request) { subject.send(method_used, endpoint) }
        end
      end
    end
  end

  describe '#parsed_response' do
    let(:object_class) { Radar::User }

    context 'when response is single object' do
      around { |test| VCR.use_cassette('/client/get_user') { test.run } }

      let(:response) { subject.get('/v1/users/611d5b8681163300488639f1') }
      let(:parsed_response) { subject.parsed_response(response, object_class: object_class) }

      it { expect(parsed_response).to be_a(object_class) }
    end

    context 'when response is collection' do
      around { |test| VCR.use_cassette('/client/get_users') { test.run } }

      let(:response_collection) { subject.get('/v1/users') }
      let(:parsed_response) { subject.parsed_response(response_collection, object_class: object_class) }

      it { expect(parsed_response).to be_a(Array) }

      it 'converts all response items as the expect object' do
        expect(parsed_response.all? { |item| item.is_a?(object_class) }).to eq true
      end
    end
  end

  describe 'errors' do
    context 'when get 404' do
      around { |test| VCR.use_cassette('/client/get_user_404') { test.run } }

      it 'raises' do
        expect { subject.get('/v1/users/user_id_404') }.to raise_error Radar::API::NotFoundError
      end
    end

    context 'when get 400' do
      around { |test| VCR.use_cassette('/client/create_user_400') { test.run } }

      it 'raises' do
        params = {
          deviceId: nil,
          latitude: nil,
          longitude: nil,
          accuracy: nil
        }
        expect { subject.post('/v1/track', params: params) }.to raise_error Radar::API::BadRequestError
      end
    end

    context 'when get other error' do
      around { |test| VCR.use_cassette('/client/get_user_500', :record => :none) { test.run } }

      it 'raises' do
        expect { subject.get('/v1/users/user_id_500') }.to raise_error Radar::API::Error
      end
    end

    context 'with error details in body' do
      around { |test| VCR.use_cassette('/client/get_user_500', :record => :none) { test.run } }

      it 'collects body errors' do
        subject.get('/v1/users/user_id_500')
      rescue Radar::API::Error => e
        expect(e).to have_attributes(code: 500, message: 'Internal server error.')
      end
    end
  end
end
