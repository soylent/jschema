module JSchema
  module Validator
    class Items < SimpleValidator
      private

      self.keywords = ['items', 'additionalItems']

      def validate_args(items, additional_items)
        additional_items_valid? additional_items
        items_valid? items
      end

      def additional_items_valid?(additional_items)
        additional_items.nil? ||
        boolean?(additional_items) ||
        valid_schema?(additional_items, 'additionalItems') ||
          invalid_schema('additionalItems', additional_items)
      end

      def items_valid?(items)
        items.nil? ||
        valid_schema?(items, 'items') ||
        schema_array?(items, 'items', false) ||
          invalid_schema('items', items)
      end

      def post_initialize(items, additional_items)
        @items = items || {}
        @additional_items = additional_items
      end

      def validate_instance(instance)
        validate_additional_items(instance) ||
        validate_all_items(instance)
      end

      def validate_additional_items(instance)
        if @additional_items == false &&
           @items.is_a?(Array) &&
           @items.size < instance.size

          "#{instance} must not contain any additional items"
        end
      end

      def validate_all_items(instance)
        instance.to_enum.each_with_index do |item, index|
          schema = schema_for_item(index)
          validation_errors = schema.validate(item)
          unless validation_errors.empty?
            return validation_errors.first
          end
        end
        nil
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
