require 'json'

module JSchema
  module JSONReference
    @mutex = Mutex.new
    @schemas = {}

    class << self
      def register_schema(schema)
        parent_schema = schema.uri == URI('#') ? schema : schema.parent
        schema_key = key(schema.uri, parent_schema)

        @mutex.synchronize do
          @schemas[schema_key] = schema
        end
      end

      def dereference(uri, schema)
        schema_key = key(uri, schema)
        cached_schema = @mutex.synchronize do
          @schemas[schema_key] if schema_key
        end

        if cached_schema
          cached_schema
        elsif uri.absolute? && !schema_part?(uri, schema)
          build_external_schema(uri, schema)
        end
      end

      private

      def schema_part?(uri, schema)
        if schema
          uri1_base = uri.dup
          uri1_base.fragment = ''

          uri2_base = schema.uri.dup
          uri2_base.fragment = ''

          uri1_base == uri2_base
        else
          false
        end
      end

      def build_external_schema(uri, schema)
        unless valid_external_uri?(uri)
          fail InvalidSchema, "Invalid URI for external schema: #{uri}"
        end

        schema_data = JSON.parse download_schema(uri)
        parent_schema = schema && schema.parent
        Schema.build(schema_data, parent_schema, uri.to_s)
      rescue JSON::ParserError, Timeout::Error
        raise InvalidSchema, "Failed to download external schema: #{uri}"
      end

      def valid_external_uri?(uri)
        uri.is_a?(URI::HTTP) && uri.absolute?
      end

      def download_schema(uri)
        request = Net::HTTP::Get.new(uri.to_s)
        request['Accept'] = 'application/json+schema'

        http = Net::HTTP.new(uri.hostname, uri.port)
        http.read_timeout = 3
        http.open_timeout = 2
        http.continue_timeout = 1

        http.request(request).body
      end

      def key(uri, schema)
        if schema
          root_schema = root(schema)
          "#{root_schema.object_id}:#{uri}"
        else
          uri.to_s
        end
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
