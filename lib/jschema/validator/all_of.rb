# frozen_string_literal: true

module JSchema
  module Validator
    class AllOf < ValidatorBase
      private

      self.keywords = ['allOf']

      def validate_args(all_of)
        schema_array?(all_of, 'allOf') || invalid_schema('allOf', all_of)
      end

      def post_initialize(all_of)
        @all_of = all_of.map.with_index do |sch, index|
          Schema.build(sch, parent, "allOf/#{index}")
        end
      end

      def validate_instance(instance)
        valid = @all_of.all? do |schema|
          schema.valid?(instance)
        end

        "#{instance} must be valid against all the schemas" unless valid
      end
    end
  end
end
