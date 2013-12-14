module JSchema
  module Validator
    class OneOf < SimpleValidator
      private

      self.keywords = ['oneOf']

      def validate_args(one_of)
        schema_array?(one_of) || invalid_schema('oneOf', one_of)
      end

      def post_initialize(one_of)
        @one_of = one_of.map.with_index do |sch, index|
          Schema.build(sch, parent, "oneOf/#{index}")
        end
      end

      def valid_instance?(instance)
        @one_of.one? do |schema|
          schema.valid?(instance)
        end
      end
    end
  end
end
