require 'helper'

require 'support/validator_assertion_helpers'

class TestUniqueItems < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_boolean
    assert_raises_unless 'uniqueItems', :boolean
  end

  def test_passing_validation_when_unique_items_is_true
    assert validator(true).valid?([1, 2])
  end

  def test_passing_validation_when_unique_items_is_false
    assert validator(false).valid?([1, 1])
  end

  def test_failing_validation
    refute validator(true).valid?([1, 1])
  end

  private

  def validator_class
    JSchema::Validator::UniqueItems
  end
end
