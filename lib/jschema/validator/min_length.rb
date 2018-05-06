# frozen_string_literal: true

require 'jschema/string_length_validator'

module JSchema
  module Validator
    # A string instance is valid against this keyword if its length is
    # greater than, or equal to, the value of this keyword.
    class MinLength < StringLengthValidator
      private

      self.keywords = ['minLength']

      def validate_args(min_length)
        if valid_length_limit?(min_length, 0)
          true
        else
          invalid_schema 'minLength', min_length
        end
      end

      def validate_instance(instance)
        "#{instance} is too short" if instance.size < @length_limit
      end
    end
  end
end
