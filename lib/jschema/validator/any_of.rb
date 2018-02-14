module JSchema
  module Validator
    class AnyOf < ValidatorBase
      private

      self.keywords = ['anyOf']

      def validate_args(any_of)
        schema_array?(any_of, 'anyOf') || invalid_schema('anyOf', any_of)
      end

      def post_initialize(any_of)
        @any_of = any_of.map.with_index do |sch, index|
          Schema.build(sch, parent, "anyOf/#{index}")
        end
      end

      def validate_instance(instance)
        valid = @any_of.any? do |schema|
          schema.valid?(instance)
        end

        unless valid
          "#{instance} must be valid against any of the schemas"
        end
      end
    end
  end
end
