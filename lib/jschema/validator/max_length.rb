# frozen_string_literal: true

require 'jschema/string_length_validator'

module JSchema
  module Validator
    # A string instance is valid against this keyword if its length is
    # less than, or equal to, the value of this keyword.
    class MaxLength < StringLengthValidator
      private

      self.keywords = ['maxLength']

      def validate_args(max_length)
        if valid_length_limit?(max_length, 1)
          true
        else
          invalid_schema 'maxLength', max_length
        end
      end

      def validate_instance(instance)
        "#{instance} is too long" if instance.size > @length_limit
      end
    end
  end
end
