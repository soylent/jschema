module JSchema
  module Validator
    class MinItems < SimpleValidator
      private

      self.keywords = ['minItems']

      def validate_args(min_items)
        greater_or_equal_to?(min_items, 0) ||
          invalid_schema('minItems', min_items)
      end

      def post_initialize(min_items)
        @min_items = min_items
      end

      def validate_instance(instance)
        if instance.size < @min_items
          "#{instance} has too few items"
        end
      end

      def applicable_type
        Array
      end
    end
  end
end
