# frozen_string_literal: true

require 'webrick/httputils'

module JSchema
  # Schema URI
  #
  # @api private
  class SchemaURI
    class << self
      # Generate a schema URI
      #
      # @see RFC 3986, cl. 5.1
      # @param schema_id [String] schema id
      # @param parent_schema [Schema] parent schema
      # @param id [String] default schema id
      # @return [URI::Generic] schema URI
      # @raise [InvalidSchema] if schema base URI cannot be established
      def build(schema_id, parent_schema, id)
        if parent_schema
          if parent_schema.uri.absolute?
            new_uri_part = schema_id ||
              join_fragments(parent_schema.uri.fragment, id)

            parent_schema.uri.merge(new_uri_part).normalize
          elsif parent_schema.uri.path.empty?
            join_fragments(parent_schema.uri.fragment, id)
          else
            # RFC 3986, cl. 5.1.4
            raise InvalidSchema, 'Cannot establish base URI'
          end
        else
          uri(schema_id || id || '#')
        end
      end

      private

      def join_fragments(primary, secondary)
        uri('#' + File.join(primary || '', secondary || ''))
      end

      def uri(uri_string)
        # NOTE: We need to escape % because URI class does not allow such
        # characters within URI fragment (which is wrong). Originally I used
        # URI.escape(str, '%'), but this method has become obsolete.
        escaped_uri = WEBrick::HTTPUtils._escape(uri_string, /([%])/)
        URI(escaped_uri)
      end
    end
  end
end
