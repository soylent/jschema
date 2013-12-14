module JSchema
  module Validator
    class Type < SimpleValidator
      private

      self.keywords = ['type']

      def validate_args(type)
        if type.is_a?(String) || unique_non_empty_array?(type)
          true
        else
          invalid_schema 'type', type
        end
      end

      def post_initialize(type)
        json_types = Array(type)
        @ruby_classes = json_types.map do |json_type|
          json_type_to_ruby_class(json_type)
        end.flatten.compact
      end

      def valid_instance?(instance)
        @ruby_classes.one? do |type|
          instance.is_a?(type)
        end
      end

      private

      def json_type_to_ruby_class(json_type)
        case json_type
        when 'object'  then Hash
        when 'null'    then NilClass
        when 'string'  then String
        when 'integer' then [Fixnum, Bignum]
        when 'array'   then Array
        when 'boolean' then [TrueClass, FalseClass]
        when 'number'  then [Fixnum, Float, BigDecimal, Bignum]
        else invalid_schema('type', json_type)
        end
      end
    end
  end
end
