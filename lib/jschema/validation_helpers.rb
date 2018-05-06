# frozen_string_literal: true

module JSchema
  # Helper methods for checking validator arguments
  #
  # @api private
  module ValidationHelpers
    # Returns true if a given value is true or false
    #
    # @param value [Object]
    # @return [Boolean]
    def boolean?(value)
      value.is_a?(TrueClass) || value.is_a?(FalseClass)
    end

    # Returns true if a given value is an integer
    #
    # @param value [Object]
    # @return [Boolean]
    def integer?(value)
      value.is_a?(Integer)
    end

    # Returns true if a given value is >= limit
    #
    # @param value [Object]
    # @param limit [Numeric]
    # @return [Boolean]
    def greater_or_equal_to?(value, limit)
      integer?(value) && value >= limit
    end

    # Returns true if a given value is a number
    #
    # @param value [Object]
    # @return [Boolean]
    def number?(value)
      value.is_a?(Numeric)
    end

    # Returns true if a given value is a non-empty array
    #
    # @param value [Object]
    # @return [Boolean]
    def non_empty_array?(value, uniqueness_check = true)
      result = value.is_a?(Array) && !value.empty?
      if uniqueness_check
        result && value.size == value.uniq.size
      else
        result
      end
    end

    # Returns true if a given value is a list of valid JSON schemas
    #
    # @param value [Object]
    # @param id [String] parent schema id
    # @param uniqueness_check [Boolean] check that all schemas are unique
    # @return [Boolean]
    def schema_array?(value, id, uniqueness_check = true)
      non_empty_array?(value, uniqueness_check) &&
        value.to_enum.with_index.all? do |schema, index|
          full_id = [id, index].join('/')
          valid_schema? schema, full_id
        end
    end

    # Returns true if a given JSON schema is valid
    #
    # @param schema [Object] schema
    # @param id [String] schema id
    # @return [Boolean]
    def valid_schema?(schema, id)
      schema.is_a?(Hash) && Schema.build(schema, parent, id)
    rescue InvalidSchema
      false
    end
  end
end
