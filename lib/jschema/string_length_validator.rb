# frozen_string_literal: true

module JSchema
  class StringLengthValidator < ValidatorBase
    private

    def post_initialize(length_limit)
      @length_limit = length_limit
    end

    def applicable_type
      String
    end

    def valid_length_limit?(length_limit, min_length_limit)
      greater_or_equal_to? length_limit, min_length_limit
    end
  end
end
