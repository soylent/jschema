# frozen_string_literal: true

require 'jschema/json_reference'
require 'jschema/schema_ref'
require 'jschema/schema_uri'
require 'jschema/validator'

module JSchema
  class Schema
    VERSION_ID = 'http://json-schema.org/draft-04/schema#'

    class << self
      def build(sch = {}, parent = nil, id = nil)
        schema = sch || {}

        check_schema_version schema

        if (json_reference = schema['$ref'])
          unescaped_ref = json_reference.gsub(/~1|~0/, '~1' => '/', '~0' => '~')
          SchemaRef.new(URI(unescaped_ref), parent)
        else
          uri = SchemaURI.build(schema['id'], parent, id)
          parent && JSONReference.dereference(uri, parent) || begin
            jschema = new(schema, uri, parent)
            register_definitions schema, jschema
            JSONReference.register_schema jschema
          end
        end
      end

      private

      def check_schema_version(schema)
        version = schema['$schema']

        return unless version
        return if version == VERSION_ID

        raise InvalidSchema, 'Specified schema version is not supported'
      end

      def register_definitions(schema, parent)
        definitions = schema['definitions']

        return unless definitions

        definitions.each do |definition, sch|
          schema_def = build(sch, parent, "definitions/#{definition}")
          JSONReference.register_schema schema_def
        end
      end
    end

    attr_reader :uri, :parent

    def initialize(schema, uri, parent)
      @uri = uri
      @parent = parent
      @schema = schema
      @validators = Validator.build(schema, self)
    end

    def valid?(instance)
      validate(instance).empty?
    end

    def validate(instance)
      @validators.map { |validator| validator.validate(instance) }.compact
    end

    def fragment(path)
      JSchema::JSONReference.dereference(URI.parse(path), self)
    end

    def to_s
      uri.to_s
    end
  end
end
