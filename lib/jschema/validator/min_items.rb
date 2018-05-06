# frozen_string_literal: true

module JSchema
  module Validator
    # An array instance is valid against "minItems" if its size is
    # greater than, or equal to, the value of this keyword.
    class MinItems < ValidatorBase
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
        "#{instance} has too few items" if instance.size < @min_items
      end

      def applicable_type
        Array
      end
    end
  end
end
