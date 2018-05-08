# frozen_string_literal: true

require 'json'

module JSchema
  # JSON reference
  #
  # @api private
  module JSONReference
    MUTEX = Mutex.new
    private_constant :MUTEX

    SCHEMAS = {}
    private_constant :SCHEMAS

    class << self
      # Register a schema so that it can be dereferenced later by its URI
      #
      # @param schema [Schema]
      # @return [void]
      def register_schema(schema)
        schema_key = key(normalize(schema.uri), schema)

        MUTEX.synchronize { SCHEMAS[schema_key] = schema }
      end

      # Look up a schema by URI relative to another schema
      #
      # @param uri [URI::Generic] schema URI
      # @param schema [Schema] base schema
      # @return [Schema]
      def dereference(uri, schema)
        schema_key = key(expand_uri(uri, schema), schema)
        cached_schema = MUTEX.synchronize do
          SCHEMAS[schema_key] if schema_key
        end

        if cached_schema
          cached_schema
        elsif uri.absolute? && !schema_part?(uri, schema)
          build_external_schema(uri, schema)
        end
      end

      private

      def expand_uri(uri, schema)
        if schema&.uri&.absolute?
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
          raise InvalidSchema, "Invalid URI for external schema: #{uri}"
        end

        schema_data = JSON.parse download_schema(uri)
        parent_schema = schema&.parent
        Schema.build(schema_data, parent_schema, uri.to_s)
      rescue JSON::ParserError => error
        raise InvalidSchema, error.message
      end

      def valid_external_uri?(uri)
        uri.is_a?(URI::HTTP) && uri.absolute?
      end

      def download_schema(url, max_redirects: 3)
        max_redirects.times do
          request = Net::HTTP::Get.new(url.to_s)
          request['Accept'] = 'application/json+schema'

          http = Net::HTTP.new(url.hostname, url.port)
          response = http.request(request)

          return response.body unless response.is_a?(Net::HTTPRedirection)

          url = URI.parse(response['location'])
        end

        raise InvalidSchema, "Too many redirects; last location: #{url}"
      rescue Timeout::Error, Errno::ECONNREFUSED => error
        raise InvalidSchema, "Download failed #{url}: #{error.message.inspect}"
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
