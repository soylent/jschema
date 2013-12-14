module JSchema
  module Validator
    class Items < SimpleValidator
      private

      self.keywords = ['items', 'additionalItems']

      def validate_args(items, additional_items)
        validate_additional_items additional_items
        validate_items items
      end

      def validate_additional_items(additional_items)
        additional_items.nil? ||
        boolean?(additional_items) ||
        valid_schema?(additional_items) ||
          invalid_schema('additionalItems', additional_items)
      end

      def validate_items(items)
        items.nil? ||
        valid_schema?(items) ||
        schema_array?(items) ||
          invalid_schema('items', items)
      end

      def post_initialize(items, additional_items)
        @items = items
        @additional_items = additional_items
      end

      def valid_instance?(instance)
        additional_items_allowed?(instance) &&
        all_items_valid?(instance)
      end

      def additional_items_allowed?(instance)
        not
          @additional_items == false &&
          @items.is_a?(Array) &&
          @items.size < instance.size
      end

      def all_items_valid?(instance)
        instance.to_enum.with_index.all? do |item, index|
          schema = schema_for_item(index)
          schema.valid?(item)
        end
      end

      def schema_for_item(index)
        case @items
        when Array
          if index < @items.size
            Schema.build @items[index], parent, "items/#{index}"
          elsif @additional_items.is_a?(Hash)
            Schema.build @additional_items, parent, 'additionalItems'
          else
            Schema.build
          end
        when Hash
          Schema.build @items, parent, 'items'
        else
          fail UnknownError
        end
      end

      def applicable_types
        [Array]
      end
    end
  end
end
