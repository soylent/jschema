# frozen_string_literal: true

module JSchema
  module Validator
    class MaxItems < ValidatorBase
      private

      self.keywords = ['maxItems']

      def validate_args(max_items)
        greater_or_equal_to?(max_items, 0) ||
          invalid_schema('maxItems', max_items)
      end

      def post_initialize(max_items)
        @max_items = max_items
      end

      def validate_instance(instance)
        "#{instance} has too many items" if instance.size > @max_items
      end

      def applicable_type
        Array
      end
    end
  end
end
