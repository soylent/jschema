# frozen_string_literal: true

module JSchema
  module Validator
    # If this keyword has boolean value false, the instance validates
    # successfully. If it has boolean value true, the instance
    # validates successfully if all of its elements are unique.
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
