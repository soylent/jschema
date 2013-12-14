module JSchema
  module Validator
    class AnyOf < SimpleValidator
      private

      self.keywords = ['anyOf']

      def validate_args(any_of)
        schema_array?(any_of) || invalid_schema('anyOf', any_of)
      end

      def post_initialize(any_of)
        @any_of = any_of.map.with_index do |sch, index|
          Schema.build(sch, parent, "anyOf/#{index}")
        end
      end

      def valid_instance?(instance)
        @any_of.any? do |schema|
          schema.valid?(instance)
        end
      end
    end
  end
end
