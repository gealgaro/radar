module Radar
  module API
    class NestedResource < Resource
      def self.resource_base_path(path_base: 'v1')
        raise NotImplementedError, 'Radar::API::NestedResource is an abstract class' if self == NestedResource

        path_base + self::PARENT_CLASS::RESOURCE_NAME[:plural]
      end
    end
  end
end
