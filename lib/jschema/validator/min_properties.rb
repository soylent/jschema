module JSchema
  module Validator
    class MinProperties < SimpleValidator
      private

      self.keywords = ['minProperties']

      def validate_args(min_properties)
        if greater_or_equal_to?(min_properties, 0)
          true
        else
          invalid_schema 'minProperties', min_properties
        end
      end

      def post_initialize(min_properties)
        @min_properties = min_properties
      end

      def applicable_types
        [Hash]
      end

      def valid_instance?(instance)
        instance.keys.size >= @min_properties
      end
    end
  end
end
