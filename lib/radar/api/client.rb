require 'net/http'
require 'uri'
require 'json'

module Radar
  module API
    class Client
      VERB_MAP = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        patch: Net::HTTP::Patch,
        delete: Net::HTTP::Delete
      }.freeze

      def initialize
        uri = URI.parse(base_uri)
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = Radar.use_ssl
      end

      attr_reader :http

      def get(path, params: {})
        request :get, path, params
      end

      def post(path, params: {})
        request :post, path, params
      end

      def put(path, params: {})
        request :put, path, params
      end

      def patch(path, params: {})
        request :patch, path, params
      end

      def delete(path)
        request :delete, path
      end

      def parsed_response(response, object_class:)
        response_hash = JSON.parse(response.body)
        response_resource = response_hash[object_class::RESOURCE_NAME[:plural]]
        if collection?(response_resource)
          response_resource.map { |json_item| object_class.new(json_item) }
        else
          object_class.new(response_hash[object_class::RESOURCE_NAME[:singular]])
        end
      end

      private

      def base_uri
        @base_uri ||= Radar.use_ssl ? "https://#{Radar.api_host}/" : "http://#{Radar.api_host}/"
      end

      def collection?(response_body)
        response_body && response_body.is_a?(Array)
      end

      def request(method, path, params = {})
        case method
        when :get
          request = VERB_MAP[method].new(encode_path(path, params), headers)
        else
          request = VERB_MAP[method].new(encode_path(path), headers)
          request.body = parameterize(params).to_json
        end
        handle_response(http.request(request))
      end

      def handle_response(response)
        return response if %w[200 201 202 204].include?(response.code)
        handle_error(response)
      end

      def handle_error(response)
        error_params = JSON.parse(response.body, symbolize_names: true)[:meta]
        case response.code
        when '400'
          raise Radar::API::BadRequestError.new(error_params)
          # raise Radar::API::UnprocessableEntityError.new(error_params)
        when '401'
          raise Radar::API::UnauthorizedError.new(error_params)
        when '402'
          raise Radar::API::UsageError.new(error_params)
        when '403'
          raise Radar::API::ForbiddenError.new(error_params)
        when '404'
          raise Radar::API::NotFoundError.new(error_params)
        when '409'
          raise Radar::API::ConflictError.new(error_params)
        when '422'
          raise Radar::API::UnprocessableEntityError.new(error_params)
        when '429'
          raise Radar::API::TooManyRequestsError.new(error_params)
        when '451'
          raise Radar::API::UnavailableError.new(error_params)
        else
          raise Radar::API::Error.new(error_params)
        end
      end

      def encode_path(path, params = nil)
        encoded_path = URI.encode(path)
        return path if params.nil?

        encoded_params = URI.encode_www_form(params)
        [encoded_path, encoded_params].join('?')
      end

      def headers
        @headers ||= { 'Authorization' => "#{Radar.secret_token}", 'Content-Type' => 'application/json' }
      end

      def parameterize(object)
        object.tap do |obj|
          return object.map { |item| parameterize(item) } if object.is_a?(Array)

          obj.keys.each do |key|
            obj[key] = parameterize_object(obj[key]) unless (obj[key].is_a?(String) || obj[key].is_a?(Numeric) || obj[key].is_a?(Boolean))
            obj[key.to_s.to_camel_case] = obj.delete(key)
          end
        end
      end

      def parameterize_object(object)
        return parameterize(object.to_h) if Radar::API::Resource.descendants.include?(object.class)
        return parameterize(object) if object.is_a?(Hash)
        return object.map { |item| item.is_a?(String) ? item : parameterize_object(item) } if object.is_a?(Array)
      end
    end
  end
end
