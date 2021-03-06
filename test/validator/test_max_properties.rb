# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'
require 'support/shared/properties_limit_tests'

class TestMaxProperties < Minitest::Test
  include ValidatorAssertionHelpers
  include PropertiesLimitTests

  def test_building_validator_from_schema
    validator = build_from_schema('maxProperties' => 10)
    assert_instance_of JSchema::Validator::MaxProperties, validator
  end

  def test_passing_validation
    assert validator(1).valid?('test' => 1)
  end

  def test_failing_validation
    refute validator(1).valid?('test1' => 1, 'test2' => 2)
  end

  private

  def validator_class
    JSchema::Validator::MaxProperties
  end
end
