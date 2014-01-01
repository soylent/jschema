module JSchema
  class << self
    def LimitValidator(name, method)
      exclusive = "exclusive#{name.capitalize}"

      Class.new(SimpleValidator) do
        private

        self.keywords = [name, exclusive]

        define_method(:validate_args) do |limit, exclusive_limit|
          number?(limit) || invalid_schema(name, limit)
          exclusive_limit.nil? || boolean?(exclusive_limit) ||
            invalid_schema(exclusive, exclusive_limit)
        end

        define_method(:post_initialize) do |limit, exclusive_limit|
          @limit = limit
          @exclusive_limit = exclusive_limit
        end

        define_method(:validate_instance) do |instance|
          cmp_method = @exclusive_limit ? method : method + '='
          unless instance.public_send(cmp_method, @limit)
            "#{instance} must be #{cmp_method} than #{@limit}"
          end
        end

        def applicable_types
          [Fixnum, Bignum, Float, BigDecimal]
        end
      end
    end
  end
end
