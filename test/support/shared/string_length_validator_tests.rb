# frozen_string_literal: true

module StringLengthValidatorTests
  def test_that_argument_can_be_big_integer
    validator(2**64)
  end

  def test_that_argument_is_integer
    assert_raises(JSchema::InvalidSchema) { validator('invalid') }
  end

  def test_that_argument_is_not_null
    assert_raises(JSchema::InvalidSchema) { validator(nil) }
  end

  def test_that_validation_always_passes_for_non_string_instances
    assert validator(1).valid?(nil)
    assert validator(1).valid?([1, 2])
  end
end
