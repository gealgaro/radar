module Radar
  class Geofence < API::Resource
    RESOURCE_NAME = { singular: 'geofence', plural: 'geofences' }.freeze

    def self.all
      path = resource_base_path
      response = api_client.get(path, params: nil)
      api_client.parsed_response(response, object_class: self)
    end

    def self.find(id:)
      path = [resource_base_path, id].join('/')
      response = api_client.get(path, params: nil)
      api_client.parsed_response(response, object_class: self)
    end

    def self.upsert(tag:, external_id:, params:)
      path = [resource_base_path, tag, external_id].join('/')
      response = api_client.put(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end

    def self.delete(id:)
      path = [resource_base_path, id].join('/')
      api_client.delete(path)
    end

    def self.delete_by(tag:, external_id:)
      path = [resource_base_path, tag, external_id].join('/')
      api_client.delete(path)
    end

    def self.users(tag:, external_id:, params:)
      path = [resource_base_path, tag, external_id, 'users'].join('/')
      response = api_client.get(path, params: params)
      api_client.parsed_response(response, object_class: self)
    end
  end
end
