module JSchema
  module Validator
    class Properties < ValidatorBase
      private

      self.keywords = [
        'properties',
        'patternProperties',
        'additionalProperties'
      ]

      def validate_args(properties, pattern_properties, additional_properties)
        validate_properties(properties)
        validate_pattern_properties(pattern_properties)
        validate_additional_properties(additional_properties)
      end

      def validate_properties(properties)
        valid_properties?(properties) ||
          invalid_schema('properties', properties)
      end

      def validate_pattern_properties(pattern_properties)
        valid_properties?(pattern_properties) ||
          invalid_schema('patternProperties', pattern_properties)
      end

      def validate_additional_properties(additional_properties)
        (valid_properties?(additional_properties) ||
          boolean?(additional_properties)) ||
          invalid_schema('additionalProperties', additional_properties)
      end

      def valid_properties?(properties)
        properties.nil? || properties.is_a?(Hash)
      end

      def post_initialize(properties, pattern_properties, additional_properties)
        @properties =
          if properties.is_a?(Hash)
            properties.each_with_object({}) do |(field, sch), res|
              res[field] = Schema.build(sch, parent, "properties/#{field}")
            end
          end

        @additional_properties =
          if additional_properties.is_a?(Hash)
            Schema.build(additional_properties, parent, 'additionalProperties')
          else
            additional_properties
          end

        @pattern_properties = pattern_properties
      end

      def applicable_type
        Hash
      end

      def validate_instance(instance)
        instance.each do |field, value|
          schemas = schemas_for(field)

          if schemas.empty? && @additional_properties == false
            return "#{instance} must not have any additional fields"
          end

          schemas.each do |schema|
            validation_errors = schema.validate(value)
            unless validation_errors.empty?
              return validation_errors.first
            end
          end
        end
        nil
      end

      private

      def schemas_for(field)
        schemas = pattern_properties_schema(field)

        if (psch = properties_schema(field))
          schemas << psch
        end

        if schemas.empty? && (asch = additional_properties_schema)
          schemas << asch
        end

        schemas
      end

      def properties_schema(field)
        @properties[field] if @properties.is_a?(Hash)
      end

      def additional_properties_schema
        if @additional_properties.respond_to?(:validate)
          @additional_properties 
        end
      end

      def pattern_properties_schema(field)
        schemas = []
        if @pattern_properties.is_a?(Hash)
          @pattern_properties.each do |pattern, sch|
            if field.match(pattern)
              schemas << Schema.build(sch, parent, "patternProperties/#{field}")
            end
          end
        end
        schemas
      end
    end
  end
end
