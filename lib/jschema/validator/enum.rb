module JSchema
  module Validator
    class Enum < SimpleValidator
      private

      self.keywords = ['enum']

      def validate_args(enum)
        unique_non_empty_array?(enum) || invalid_schema('enum', enum)
      end

      def post_initialize(enum)
        @enum = enum
      end

      def valid_instance?(instance)
        @enum.include? instance
      end
    end
  end
end
