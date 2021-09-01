module Radar
  module API
    class Error < StandardError
      attr_reader :code, :param, :message

      def initialize(**error_params)
        @code = error_params.dig(:code)
        @param = error_params.dig(:param)
        @message = error_params.dig(:message)
      end
    end
  end
end
