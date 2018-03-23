require 'jschema/validation_helpers'

module JSchema
  class ValidatorBase
    include ValidationHelpers

    class << self
      def build(schema, parent)
        args = schema.values_at(*keywords)
        new(*args, parent) unless args.compact.empty?
      end

      private

      attr_accessor :keywords
    end

    attr_reader :parent

    def initialize(*args, parent)
      @parent = parent

      if validate_args(*args)
        post_initialize(*args)
      else
        raise InvalidSchema
      end
    end

    def valid?(instance)
      validate(instance).nil?
    end

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
