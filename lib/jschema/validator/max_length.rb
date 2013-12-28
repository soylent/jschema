module JSchema
  module Validator
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
        if instance.size > @length_limit
          "#{instance} is too long"
        end
      end
    end
  end
end
