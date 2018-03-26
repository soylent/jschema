# frozen_string_literal: true

module JSchema
  module Validator
    class OneOf < ValidatorBase
      private

      self.keywords = ['oneOf']

      def validate_args(one_of)
        schema_array?(one_of, 'oneOf') || invalid_schema('oneOf', one_of)
      end

      def post_initialize(one_of)
        @one_of = one_of.map.with_index do |sch, index|
          Schema.build(sch, parent, "oneOf/#{index}")
        end
      end

      def validate_instance(instance)
        valid = @one_of.one? do |schema|
          schema.valid?(instance)
        end

        unless valid
          "#{instance} must be valid against exactly one schema"
        end
      end
    end
  end
end
