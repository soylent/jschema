module JSchema
  module Validator
    class Minimum < SimpleValidator
      private

      self.keywords = ['minimum', 'exclusiveMinimum']

      def validate_args(minimum, exclusive_minimum)
        number?(minimum) || invalid_schema('minimum', minimum)
        exclusive_minimum.nil? || boolean?(exclusive_minimum) ||
          invalid_schema('exclusiveMinimum', exclusive_minimum)
      end

      def post_initialize(minimum, exclusive_minimum)
        @minimum = minimum
        @exclusive_minimum = exclusive_minimum
      end

      def validate_instance(instance)
        method = @exclusive_minimum ? :> : :>=
        unless instance.public_send(method, @minimum)
          "#{instance} must be #{method} than #{@minimum}"
        end
      end

      def applicable_types
        [Numeric]
      end
    end
  end
end
