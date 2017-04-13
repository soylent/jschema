module JSchema
  module LocalSchemas
    base = File.expand_path(File.join("..", "..", "..", "local_schemas"), __FILE__)
    @local_schemas = {
      "http://json-schema.org/draft-04/hyper-schema#" => File.join(base, "json-schema", "draft-04", "hyper-schema.json"),
      "http://json-schema.org/draft-04/schema#" => File.join(base, "json-schema", "draft-04", "schema.json"),
      "http://swagger.io/v2/schema.json#" => File.join(base, "swagger", "v2.0", "schema.json")
    }
    class << self
      def add schema_uri, schema_or_path
        uri = URI(schema_uri)
        uri.fragment = ''
        unless JSONReference.valid_external_uri?(uri)
          raise ArgumentError, "#{uri} is not an absolute URI"
        end
        @local_schemas[uri.to_s] = schema_or_path
      end
      def remove schema_uri
        uri = URI(schema_uri)
        uri.fragment = ''
        @local_schemas.delete(uri.to_s)
      end
      def to_h
        @local_schemas.dup
      end
    end
  end
end
