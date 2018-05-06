# frozen_string_literal: true

require 'jschema/validation_helpers'

module JSchema
  # Superclass for all validators (template method)
  class ValidatorBase
    include ValidationHelpers

    class << self
      # Create a new validator instance based on a given JSON schema
      #
      # @param schema [Hash] JSON schema
      # @param parent [Schema] parent schema
      # @return [ValidatorBase, nil]
      def build(schema, parent)
        args = schema.values_at(*keywords)
        new(*args, parent) unless args.compact.empty?
      end

      private

      attr_accessor :keywords
    end

    # @return [Schema] parent schema
    attr_reader :parent

    # @param *args [Array<Object>] validator args
    # @param parent [Schema] parent schema
    # @raise [InvalidSchema] if the arguments are invalid
    def initialize(*args, parent)
      @parent = parent

      raise InvalidSchema unless validate_args(*args)

      post_initialize(*args)
    end

    # Returns true if a given instance is valid
    #
    # @param instance [Object]
    # @return [Boolean]
    def valid?(instance)
      validate(instance).nil?
    end

    # Validates a given instance
    #
    # @param instance [Object]
    # @return [Array<String>] list of validation error messages
    def validate(instance)
      if !applicable_type || instance.is_a?(applicable_type)
        validate_instance(instance)
      end
    end

    private

    # Hook method
    def applicable_type; end

    def invalid_schema(keyword, value)
      raise InvalidSchema, "Invalid `#{keyword}` value: #{value.inspect}"
    end
  end
end
