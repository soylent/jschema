module JSchema
  module Validator
    class Pattern < SimpleValidator
      private

      self.keywords = ['pattern']

      def validate_args(pattern)
        Regexp.new(pattern)
        true
      rescue TypeError
        invalid_schema 'pattern', pattern
      end

      def post_initialize(pattern)
        @pattern = pattern
      end

      def valid_instance?(instance)
        !!instance.match(@pattern)
      end

      def applicable_types
        [String]
      end
    end
  end
end
