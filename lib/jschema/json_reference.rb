module JSchema
  module JSONReference
    @schemas = {}

    class << self
      def register_schema(schema)
        schema_key = key(schema.uri, schema)
        @schemas[schema_key] = schema
      end

      def dereference(uri, schema)
        schema_key = key(uri, schema)
        @schemas[schema_key] || fail(InvalidSchema)
      end

      private

      def key(uri, schema)
        root_schema = root(schema)
        "#{root_schema.object_id}:#{uri}"
      end

      def root(schema)
        root = schema
        loop do
          break if root.parent.nil?
          root = root.parent
        end
        root
      end
    end
  end
end
