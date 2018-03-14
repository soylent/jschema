# frozen_string_literal: true

module JSchema
  module ValidationHelpers
    def boolean?(value)
      value.is_a?(TrueClass) || value.is_a?(FalseClass)
    end

    def integer?(value)
      value.is_a?(Integer)
    end

    def greater_or_equal_to?(value, limit)
      integer?(value) && value >= limit
    end

    def number?(value)
      value.is_a?(Numeric)
    end

    def non_empty_array?(value, uniqueness_check = true)
      result = value.is_a?(Array) && !value.empty?
      if uniqueness_check
        result && value.size == value.uniq.size
      else
        result
      end
    end

    def schema_array?(value, id, uniqueness_check = true)
      non_empty_array?(value, uniqueness_check) &&
        value.to_enum.with_index.all? do |schema, index|
          full_id = [id, index].join('/')
          valid_schema? schema, full_id
        end
    end

    def valid_schema?(schema, id)
      schema.is_a?(Hash) && Schema.build(schema, parent, id)
    rescue InvalidSchema
      false
    end
  end
end
