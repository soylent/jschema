require 'helper'

require 'support/validator_assertion_helpers'

class TestPattern < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_only_valid_regexp_is_allowed
    assert_raises_unless 'pattern', :string
  end

  def test_that_validation_always_passes_for_non_strings
    assert validator('123').valid?(nil)
    assert validator('123').valid?([])
  end

  def test_passing_validation
    assert validator('123').valid?('test123')
    assert validator('\d+$').valid?('test123')
  end

  def test_failing_validation
    refute validator('123').valid?('test')
  end

  private

  def validator_class
    JSchema::Validator::Pattern
  end
end
