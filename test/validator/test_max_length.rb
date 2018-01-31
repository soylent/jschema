require 'helper'

require 'support/validator_assertion_helpers'
require_relative '../string_length_validator_tests'

class TestMaxLength < Minitest::Test
  include ValidatorAssertionHelpers
  include StringLengthValidatorTests

  def test_that_argument_is_a_positive_number
    assert_raises_for_values 'maxLength', [0]
  end

  def test_passing_validation
    assert validator(4).valid?('test')
    assert validator(10).valid?('test')
    assert validator(10).valid?('')
  end

  def test_failing_validation
    refute validator(3).valid?('test')
  end

  private

  def validator_class
    JSchema::Validator::MaxLength
  end
end
