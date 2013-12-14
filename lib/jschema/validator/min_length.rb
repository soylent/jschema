module JSchema
  module Validator
    class MinLength < JSchema::StringLengthValidator
      private

      self.keywords = ['minLength']

      def validate_args(min_length)
        if valid_length_limit?(min_length, 0)
          true
        else
          invalid_schema 'minLength', min_length
        end
      end

      def valid_instance?(instance)
        instance.size >= @length_limit
      end
    end
  end
end
