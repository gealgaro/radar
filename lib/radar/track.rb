module Radar
  class Track < API::Resource
    RESOURCE_NAME = { singular: 'user', plural: 'track' }.freeze

    def self.create(params:)
      path = resource_base_path
      response = api_client.post(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
