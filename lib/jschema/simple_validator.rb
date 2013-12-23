module JSchema
  class SimpleValidator
    class << self
      def build(schema, parent)
        # Validator keywords must be explicitly specified.
        fail UnknownError unless keywords

        args = schema.values_at(*keywords)
        new(*args, parent) unless args.compact.empty?
      end

      private

      attr_accessor :keywords
    end

    attr_reader :parent, :errors

    def initialize(*args, parent)
      @errors = []
      @parent = parent

      if validate_args(*args)
        post_initialize(*args)
      else
        fail InvalidSchema
      end
    end

    def valid?(instance)
      if !applicable_types || applicable_types.include?(instance.class)
        valid_instance?(instance) || add_error(instance)
      else
        true
      end
    end

    private

    def add_error(instance)
      validator_name = self.class.name
      @errors <<
        "#{validator_name} validation failed against #{instance.inspect}"
      false
    end

    # Hook method
    def applicable_types; end

    def invalid_schema(keyword, value)
      fail InvalidSchema, "Invalid `#{keyword}` value: #{value.inspect}"
    end

    # Argument validation helpers

    def boolean?(value)
      value.is_a?(TrueClass) || value.is_a?(FalseClass)
    end

    def integer?(value)
      value.is_a?(Fixnum) || value.is_a?(Bignum)
    end

    def greater_or_equal_to?(value, limit)
      integer?(value) && value >= limit
    end

    def number?(value)
      integer?(value) || value.is_a?(Float) || value.is_a?(BigDecimal)
    end

    def unique_non_empty_array?(value)
      value.is_a?(Array) &&
      !value.empty? &&
      value.size == value.uniq.size
    end

    def schema_array?(value)
      unique_non_empty_array?(value) &&
      value.all? { |schema| valid_schema?(schema) }
    end

    def valid_schema?(schema)
      # OPTIMIZE: schema is initialized twice.
      schema.is_a?(Hash) && !!Schema.build(schema, parent)
    rescue InvalidSchema
      false
    end
  end
end
