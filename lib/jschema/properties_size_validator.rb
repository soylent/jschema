module JSchema
  class << self
    def PropertiesSizeValidator(name, method)
      Class.new(SimpleValidator) do
        private

        self.keywords = [name]

        define_method(:validate_args) do |size_limit|
          if greater_or_equal_to?(size_limit, 0)
            true
          else
            invalid_schema name, size_limit
          end
        end

        def post_initialize(size_limit)
          @size_limit = size_limit
        end

        def applicable_types
          [Hash]
        end

        define_method(:validate_instance) do |instance|
          if instance.keys.size.public_send(method, @size_limit)
            "#{instance} size must not be #{method} #{@size_limit}"
          end
        end
      end
    end
  end
end
