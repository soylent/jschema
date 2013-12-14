module JSchema
  class StringLengthValidator < SimpleValidator
    protected

    def post_initialize(length_limit)
      @length_limit = length_limit
    end

    def applicable_types
      [String]
    end

    def valid_length_limit?(length_limit, min_length_limit)
      greater_or_equal_to? length_limit, min_length_limit
    end
  end
end
