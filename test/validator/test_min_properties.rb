require 'helper'

require 'support/validator_assertion_helpers'
require 'support/shared/properties_limit_tests'

class TestMinProperties < Minitest::Test
  include ValidatorAssertionHelpers
  include PropertiesLimitTests

  def test_building_validator_from_schema
    validator = build_from_schema('minProperties' => 10)
    assert_instance_of JSchema::Validator::MinProperties, validator
  end

  def test_passing_validation
    assert validator(0).valid?('test' => 1)
  end

  def test_failing_validation
    refute validator(3).valid?('test1' => 1, 'test2' => 2)
  end

  private

  def validator_class
    JSchema::Validator::MinProperties
  end
end
