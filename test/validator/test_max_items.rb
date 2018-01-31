require 'helper'

require 'support/validator_assertion_helpers'

class TestMaxItems < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_non_negative_iteger
    assert_raises_unless_non_negative_integer 'maxItems'
  end

  def test_passing_validation
    assert validator(3).valid?([1, 2])
  end

  def test_failing_validation
    refute validator(2).valid?([1, 2, 3])
  end

  private

  def validator_class
    JSchema::Validator::MaxItems
  end
end
