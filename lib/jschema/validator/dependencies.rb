# frozen_string_literal: true

module JSchema
  module Validator
    class Dependencies < ValidatorBase
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
        non_empty_array?(dependency) &&
        dependency.all? { |property| property.is_a?(String) }
      end

      def post_initialize(dependencies)
        @dependencies = dependencies
      end

      def validate_instance(instance)
        @dependencies.each do |property, validator|
          if instance.key?(property)
            errors = validate_against_dependency(instance, validator, property)
            unless errors.empty?
              return errors.first
            end
          end
        end and nil
      end

      def validate_against_dependency(instance, validator, property)
        case validator
        when Hash
          schema = Schema.build(validator, parent, property)
          schema.validate(instance)
        when Array
          required = Validator::Required.new(validator, nil)
          Array required.validate(instance)
        else
          raise UnknownError
        end
      end

      def applicable_type
        Hash
      end
    end
  end
end
