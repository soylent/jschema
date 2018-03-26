# frozen_string_literal: true

module JSchema
  module Validator
    class UniqueItems < ValidatorBase
      private

      self.keywords = ['uniqueItems']

      def validate_args(unique_items)
        boolean?(unique_items) || invalid_schema('uniqueItems', unique_items)
      end

      def post_initialize(unique_items)
        @unique_items = unique_items
      end

      def validate_instance(instance)
        if @unique_items && instance.size != instance.uniq.size
          "#{instance} must contain only unique items"
        end
      end

      def applicable_type
        Array
      end
    end
  end
end
