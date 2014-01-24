module JSchema
  module Validator
    class Type < SimpleValidator
      private

      self.keywords = ['type']

      def validate_args(type)
        if type.is_a?(String) || non_empty_array?(type)
          true
        else
          invalid_schema 'type', type
        end
      end

      def post_initialize(type)
        @json_types = Array(type)
        @ruby_classes = @json_types.map do |json_type|
          json_type_to_ruby_class(json_type)
        end.flatten.compact
      end

      def validate_instance(instance)
        unless @ruby_classes.one? { |type| instance.is_a?(type) }
          error_message(instance)
        end
      end

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

      def error_message(instance)
        types =
          case @json_types.size
          when 1
            @json_types.first
          when 2
            @json_types.join(' or ')
          when 3..Float::INFINITY
            @json_types[0..-2].join(', ') << ", or #{@json_types.last}"
          end

        "#{instance.inspect} must be a #{types}"
      end
    end
  end
end
