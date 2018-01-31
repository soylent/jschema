require 'helper'

require 'support/validator_assertion_helpers'

class TestRequired < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_string_array
    assert_raises_unless_string_array 'required'
  end

  def test_passing_validation
    assert validator(['test']).valid?('test' => 123)
  end

  def test_passing_validation_when_property_has_false_value
    assert validator(['test']).valid?('test' => false)
  end

  def test_failing_validation
    refute validator(['test']).valid?({})
  end

  private

  def validator_class
    JSchema::Validator::Required
  end
end
