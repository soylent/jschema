module JSchema
  module Validator
    class MaxProperties < SimpleValidator
      private

      self.keywords = ['maxProperties']

      def validate_args(max_properties)
        if greater_or_equal_to?(max_properties, 0)
          true
        else
          invalid_schema 'maxProperties', max_properties
        end
      end

      def post_initialize(max_properties)
        @max_properties = max_properties
      end

      def applicable_types
        [Hash]
      end

      def valid_instance?(instance)
        instance.keys.size <= @max_properties
      end
    end
  end
end
