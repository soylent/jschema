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
        @multiple_of = BigDecimal.new(multiple_of.to_s)
      end

      def validate_instance(instance)
        number = BigDecimal.new(instance.to_s)
        div_remainder = number % @multiple_of
        unless div_remainder == 0
          "#{instance} must be a multiple of #{@multiple_of}"
        end
      end

      def applicable_types
        [Numeric]
      end
    end
  end
end
