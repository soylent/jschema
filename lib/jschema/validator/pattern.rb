# frozen_string_literal: true

module JSchema
  module Validator
    # A string instance is considered valid if the regular expression
    # matches the instance successfully. 
    class Pattern < ValidatorBase
      private

      # Fix because of Rubinius
      unless defined? PrimitiveFailure
        class PrimitiveFailure < Exception # :nodoc:
        end
      end

      self.keywords = ['pattern']

      def validate_args(pattern)
        Regexp.new(pattern)
        true
      rescue TypeError, PrimitiveFailure, RegexpError
        invalid_schema 'pattern', pattern
      end

      def post_initialize(pattern)
        @pattern = pattern
      end

      def validate_instance(instance)
        unless instance.match(@pattern)
          "#{instance} must match pattern #{@pattern.inspect}"
        end
      end

      def applicable_type
        String
      end
    end
  end
end
