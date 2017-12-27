require 'helper'

require_relative 'assertions'
require_relative '../string_length_validator_tests'

class TestMinLength < Minitest::Test
  include Assertions
  include StringLengthValidatorTests

  def test_that_argument_is_not_a_negative_number
    assert_raises_unless_non_negative_integer 'minLength'
  end

  def test_passing_validation
    assert validator(4).valid?('test')
    assert validator(3).valid?('test')
    assert validator(0).valid?('')
  end

  def test_failing_validation
    refute validator(5).valid?('test')
  end

  private

  def validator_class
    JSchema::Validator::MinLength
  end
end
