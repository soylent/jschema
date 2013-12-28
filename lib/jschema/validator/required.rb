module JSchema
  module Validator
    class Required < SimpleValidator
      private

      self.keywords = ['required']

      def validate_args(required)
        valid_required?(required) || invalid_schema('required', required)
      end

      def post_initialize(required)
        @required = required
      end

      def applicable_types
        [Hash]
      end

      def validate_instance(instance)
        @required.each do |required_property|
          if instance[required_property].nil?
            return "#{instance} must have property `#{required_property}`"
          end
        end and nil
      end

      def valid_required?(required)
        unique_non_empty_array?(required) &&
        required.all? { |req| req.is_a?(String) }
      end
    end
  end
end
