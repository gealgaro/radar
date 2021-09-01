module Radar
  class User < API::Resource
    RESOURCE_NAME = { singular: 'user', plural: 'users' }.freeze

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

    def self.delete(id:)
      path = [resource_base_path, id].join('/')
      api_client.delete(path)
    end
  end
end
