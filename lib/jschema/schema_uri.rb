module JSchema
  class SchemaURI
    def self.build(schema, parent_schema, id)
      this_id = URI(schema['id'] || id || '#')

      # RFC 3986, cl. 5.1
      if parent_schema
        if parent_schema.uri.absolute?
          parent_schema.uri.merge(this_id).normalize
        elsif parent_schema.uri.path.empty?
          URI('#' + File.join(parent_schema.uri.fragment, id || '')) # FIXME
        else
          # RFC 3986, cl. 5.1.4
          fail InvalidSchema, 'Can not establish a base URI'
        end
      else
        this_id
      end
    end
  end
end
