# frozen_string_literal: true

module JSchema
  module Validator
    # An object instance is valid against this keyword if every item in
    # the array is the name of a property in the instance.
    class Required < ValidatorBase
      private

      self.keywords = ['required']

      def validate_args(required)
        valid_required?(required) || invalid_schema('required', required)
      end

      def post_initialize(required)
        @required = required
      end

      def applicable_type
        Hash
      end

      def validate_instance(instance)
        missing_keys = @required - instance.keys
        unless missing_keys.empty?
          keys = missing_keys.map(&:inspect).join(', ')
          "#{instance} must contain #{keys}"
        end
      end

      def valid_required?(required)
        non_empty_array?(required) &&
        required.all? { |req| req.is_a?(String) }
      end
    end
  end
end
