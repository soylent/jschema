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
        @schemas[schema_key] || build_external_schema(uri, schema)
      end

      private

      def build_external_schema(uri, schema)
        unless valid_external_uri?(uri)
          fail InvalidSchema, 'Invalid URI for external schema'
        end

        sch = JSON.parse download_schema(uri)
        register_schema Schema.new(sch, uri, schema.parent)
      rescue JSON::ParserError, Timeout::Error
        raise InvalidSchema, 'Failed to download external schema'
      end

      def valid_external_uri?(uri)
        uri.is_a?(URI::HTTP) && uri.absolute?
      end

      def download_schema(uri)
        request = Net::HTTP::Get.new(uri)
        request['Accept'] = 'application/json+schema'

        http = Net::HTTP.new(uri.hostname, uri.port)
        http.read_timeout = 1
        http.continue_timeout = 1
        http.open_timeout = 1

        http.request(request).body
      end

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
