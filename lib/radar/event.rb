module Radar
  class Event < API::Resource
    RESOURCE_NAME = { singular: 'event', plural: 'events' }.freeze

    def self.all(params: nil)
      path = resource_base_path
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.find(id:, params: nil)
      path = [resource_base_path, id].join('/')
      response = api_client.get(path)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
