module JSchema
  module Validator
    class Not < ValidatorBase
      private

      self.keywords = ['not']

      def validate_args(schema)
        valid_schema?(schema, 'not') || invalid_schema('not', schema)
      end

      def post_initialize(not_schema)
        @schema = Schema.build(not_schema, parent, 'not')
      end

      def validate_instance(instance)
        if @schema.valid?(instance)
          "#{instance} must not validate against #{@schema}"
        end
      end
    end
  end
end
