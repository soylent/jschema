module JSchema
  module Validator
    class Maximum < SimpleValidator
      private

      self.keywords = ['maximum', 'exclusiveMaximum']

      def validate_args(maximum, exclusive_maximum)
        number?(maximum) || invalid_schema('maximum', maximum)
        exclusive_maximum.nil? || boolean?(exclusive_maximum) ||
          invalid_schema('exclusiveMaximum', exclusive_maximum)
      end

      def post_initialize(maximum, exclusive_maximum)
        @maximum = maximum
        @exclusive_maximum = exclusive_maximum
      end

      def valid_instance?(instance)
        if @exclusive_maximum
          instance < @maximum
        else
          instance <= @maximum
        end
      end

      def applicable_types
        [Fixnum, Bignum, Float, BigDecimal]
      end
    end
  end
end
