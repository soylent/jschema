module JSchema
  module Validator
    class UniqueItems < SimpleValidator
      private

      self.keywords = ['uniqueItems']

      def validate_args(unique_items)
        boolean?(unique_items) || invalid_schema('uniqueItems', unique_items)
      end

      def post_initialize(unique_items)
        @unique_items = unique_items
      end

      def valid_instance?(instance)
        if @unique_items
          instance.size == instance.uniq.size
        else
          true
        end
      end

      def applicable_types
        [Array]
      end
    end
  end
end
