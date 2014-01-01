module JSchema
  class << self
    def ItemsSizeValidator(name, method)
      Class.new(SimpleValidator) do
        private

        self.keywords = [name]

        define_method(:validate_args) do |size_limit|
          greater_or_equal_to?(size_limit, 0) ||
            invalid_schema(name, size_limit)
        end

        def post_initialize(size_limit)
          @size_limit = size_limit
        end

        define_method(:validate_instance) do |instance|
          if instance.size.public_send(method, @size_limit)
            "#{instance} size must not be #{method} #{@size_limit}"
          end
        end

        def applicable_types
          [Array]
        end
      end
    end
  end
end
