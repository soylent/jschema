module JSchema
  module Validator
    class MaxItems < SimpleValidator
      private

      self.keywords = ['maxItems']

      def validate_args(max_items)
        greater_or_equal_to?(max_items, 0) ||
          invalid_schema('maxItems', max_items)
      end

      def post_initialize(max_items)
        @max_items = max_items
      end

      def valid_instance?(instance)
        instance.size <= @max_items
      end

      def applicable_types
        [Array]
      end
    end
  end
end
