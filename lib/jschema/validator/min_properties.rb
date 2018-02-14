module JSchema
  module Validator
    class MinProperties < ValidatorBase
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

      def applicable_type
        Hash
      end

      def validate_instance(instance)
        if instance.keys.size < @min_properties
          "#{instance} has too few properties"
        end
      end
    end
  end
end
