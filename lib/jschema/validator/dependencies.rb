module JSchema
  module Validator
    class Dependencies < SimpleValidator
      private

      self.keywords = ['dependencies']

      def validate_args(dependencies)
        valid_dependencies?(dependencies) ||
          invalid_schema('dependencies', dependencies)
      end

      def valid_dependencies?(dependencies)
        dependencies.is_a?(Hash) &&
          dependencies.values.all? do |dependency|
            valid_schema_dependency?(dependency) ||
            valid_property_dependency?(dependency)
          end
      end

      def valid_schema_dependency?(dependency)
        dependency.is_a?(Hash)
      end

      def valid_property_dependency?(dependency)
        unique_non_empty_array?(dependency) &&
        dependency.all? { |property| property.is_a?(String) }
      end

      def post_initialize(dependencies)
        @dependencies = dependencies
      end

      def valid_instance?(instance)
        @dependencies.all? do |property, validator|
          if instance.key?(property)
            validate_against_dependency(instance, validator, property)
          else
            true
          end
        end
      end

      def validate_against_dependency(instance, validator, property)
        case validator
        when Hash
          schema = Schema.build(validator, parent, property)
          schema.valid?(instance)
        when Array
          required = Validator::Required.new(validator)
          required.valid?(instance)
        else
          fail UnknownError
        end
      end

      def applicable_types
        [Hash]
      end
    end
  end
end
