module Radar
  class Trip < API::Resource
    RESOURCE_NAME = { singular: 'trip', plural: 'trips' }.freeze

    def self.all(params: nil)
      path = resource_base_path
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.start(params:)
      Radar::Track.create(params: params)
    end

    def self.restart(id:)
      path = [resource_base_path, id].join('/')
      response = api_client.patch(path, params: { status: 'started' })
      api_client.parsed_response(response, object_class: self)
    end

    def self.stop(id:)
      path = [resource_base_path, id].join('/')
      response = api_client.patch(path, params: { status: 'canceled' })
      api_client.parsed_response(response, object_class: self)
    end
  end
end
