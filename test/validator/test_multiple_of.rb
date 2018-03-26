# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'

class TestMultipleOf < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_a_number
    assert_raises_unless 'multipleOf', :number, :integer
  end

  def test_that_argument_is_a_positive_number
    assert_raises_for_values 'multipleOf', [0, -0.5]
  end

  def test_passing_validation_when_argument_is_integer
    assert validator(2).valid?(4)
  end

  def test_passing_validation_when_argument_is_float
    assert validator(1.2).valid?(3.6)
  end

  def test_passing_validation_when_instance_is_negative
    assert validator(1.2).valid?(-3.6)
  end

  def test_failing_validation
    refute validator(3).valid?(7)
  end

  private

  def validator_class
    JSchema::Validator::MultipleOf
  end
end
