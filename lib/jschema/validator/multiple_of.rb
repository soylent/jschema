module JSchema
  module Validator
    class MultipleOf < SimpleValidator
      private

      self.keywords = ['multipleOf']

      def validate_args(multiple_of)
        if number?(multiple_of) && multiple_of > 0
          true
        else
          invalid_schema('multipleOf', multiple_of)
        end
      end

      def post_initialize(multiple_of)
        @multiple_of = multiple_of
      end

      def valid_instance?(instance)
        div_remainder = instance.abs % @multiple_of
        div_remainder.abs < 1e-6
      end

      def applicable_types
        [Fixnum, Bignum, Float, BigDecimal]
      end
    end
  end
end
