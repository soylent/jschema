# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'

class TestMinItems < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_non_negative_iteger
    assert_raises_unless_non_negative_integer 'minItems'
  end

  def test_passing_validation
    assert validator(1).valid?([1, 2])
    assert validator(1).valid?([1])
  end

  def test_failing_validation
    refute validator(2).valid?([1])
  end

  private

  def validator_class
    JSchema::Validator::MinItems
  end
end
