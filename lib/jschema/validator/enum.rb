# frozen_string_literal: true

module JSchema
  module Validator
    # An instance validates successfully against this keyword if its
    # value is equal to one of the elements in this keyword's array
    # value.
    class Enum < ValidatorBase
      private

      self.keywords = ['enum']

      def validate_args(enum)
        non_empty_array?(enum) || invalid_schema('enum', enum)
      end

      def post_initialize(enum)
        @enum = enum
      end

      def validate_instance(instance)
        unless @enum.include? instance
          "#{instance} must be one of: #{@enum.join(', ')}"
        end
      end
    end
  end
end
