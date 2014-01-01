module JSchema
  class << self
    def ItemsLimitValidator(name, method)
      Class.new(SimpleValidator) do
        private

        self.keywords = [name]

        define_method(:validate_args) do |limit|
          greater_or_equal_to?(limit, 0) || invalid_schema(name, limit)
        end

        def post_initialize(limit)
          @limit = limit
        end

        define_method(:validate_instance) do |instance|
          if instance.size.public_send(method, @limit)
            "#{instance} size must not be #{method} #{@limit}"
          end
        end

        def applicable_types
          [Array]
        end
      end
    end
  end
end
