# frozen_string_literal: true

module JSchema
  module Validator
    # If the instance is a number, then this keyword validates only if
    # the instance is less than or exactly equal to "maximum".
    class Maximum < ValidatorBase
      private

      self.keywords = %w[maximum exclusiveMaximum]

      def validate_args(maximum, exclusive_maximum)
        number?(maximum) || invalid_schema('maximum', maximum)
        exclusive_maximum.nil? || boolean?(exclusive_maximum) ||
          invalid_schema('exclusiveMaximum', exclusive_maximum)
      end

      def post_initialize(maximum, exclusive_maximum)
        @maximum = maximum
        @exclusive_maximum = exclusive_maximum
      end

      def validate_instance(instance)
        method = @exclusive_maximum ? :< : :<=
        unless instance.public_send(method, @maximum)
          "#{instance} must be #{method} than #{@maximum}"
        end
      end

      def applicable_type
        Numeric
      end
    end
  end
end
