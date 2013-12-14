module JSchema
  module Validator
    class Not < SimpleValidator
      private

      self.keywords = ['not']

      def validate_args(schema)
        valid_schema?(schema) || invalid_schema('not', schema)
      end

      def post_initialize(not_schema)
        @schema = Schema.build(not_schema, parent, 'not')
      end

      def valid_instance?(instance)
        !@schema.valid?(instance)
      end
    end
  end
end
