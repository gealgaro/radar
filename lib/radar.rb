require 'radar/version'

# Utils
require 'radar/utils/string'
require 'radar/utils/boolean'

# Error handling
require 'radar/api/errors/error'
require 'radar/api/errors/bad_request_error'
require 'radar/api/errors/conflict_error'
require 'radar/api/errors/forbidden_error'
require 'radar/api/errors/not_found_error'
require 'radar/api/errors/too_many_requests_error'
require 'radar/api/errors/unauthorized_error'
require 'radar/api/errors/unavailable_error'
require 'radar/api/errors/unprocessable_entity_error'
require 'radar/api/errors/usage_error'

# Api Client
require 'radar/api/client'
require 'radar/api/resource'
require 'radar/api/nested_resource'

# Api Resources
require 'radar/track'
require 'radar/trip'
require 'radar/geofence'
require 'radar/user'
require 'radar/event'

module Radar
  @api_host = 'api.radar.io'.freeze
  @use_ssl = true
  @secret_token = 'provide_your_test_secret_key'

  class << self
    attr_accessor :api_host, :use_ssl, :secret_token

    def api_resources
      @api_resources ||= API::Resource.descendants.each_with_object({}) do |descendant, resources|
        resources[descendant::RESOURCE_NAME[:plural]] = descendant
      end.freeze
    end
  end
end
