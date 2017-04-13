require 'json'

module JSchema
  module JSONReference
    @mutex = Mutex.new
    @schemas = {}

    class << self
      def register_schema(schema)
        schema_key = key(normalize(schema.uri), schema)

        @mutex.synchronize do
          @schemas[schema_key] = schema
        end
      end

      def dereference(uri, schema)
        schema_key = key(expand_uri(uri, schema), schema)
        cached_schema = @mutex.synchronize do
          @schemas[schema_key] if schema_key
        end

        if cached_schema
          cached_schema
        elsif uri.absolute? && !schema_part?(uri, schema)
          build_external_schema(uri, schema)
        end
      end

      def valid_external_uri?(uri)
        uri.is_a?(URI::HTTP) && uri.absolute?
      end

      private

      def expand_uri(uri, schema)
        if schema && schema.uri.absolute?
          normalize schema.uri.merge(uri)
        else
          normalize uri
        end
      end

      def normalize(uri)
        normalized = uri.dup
        normalized.fragment = nil if normalized.fragment == ''
        normalized.normalize
      end

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
      rescue JSON::ParserError, Timeout::Error, Errno::ECONNREFUSED, Net::HTTPBadResponse => e
        raise InvalidSchema, "Failed to download external schema #{uri}. #{e.class}: #{e.message}"
      end

      def download_schema(uri)

        uri = uri.dup
        uri.fragment = ''

        # First check local schema cache
        local = JSchema::LocalSchemas.to_h[uri.to_s]
        if local
          if local.start_with? "{"
            return local
          end
          return File.read(local)
        end

        # Then attempt to download from remote
        3.times do
          request = Net::HTTP::Get.new(uri.to_s)
          request['Accept'] = 'application/json+schema'

          http = Net::HTTP.new(uri.hostname, uri.port)
          http.read_timeout = 3
          http.open_timeout = 2
          http.continue_timeout = 1
          response = http.request(request)
          if ["301", "302"].include?(response.code)
            uri = URI.parse(response.header['location'])
          else
            return response.body
          end
        end

        raise Net::HTTPBadResponse, "Too many redirects -- last location header was #{uri}"

      end

      def key(uri, schema)
        if schema
          root_schema = root(schema)
          return "#{root_schema.object_id}:#{uri}"
        end
        uri.to_s
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
