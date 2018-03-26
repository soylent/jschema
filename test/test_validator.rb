# frozen_string_literal: true

require 'helper'

class TestValidatorInstantiation < Minitest::Test
  def test_creating_of_validators
    return_validator = Object.new
    assert_equal [return_validator], build_validators(return_validator)
  end

  def test_parsing_of_empty_schema
    assert_empty build_validators(nil)
  end

  private

  def build_validators(return_validator)
    schema = { 'keyword' => 'arg' }
    parent_schema = Object.new
    validator_class = MiniTest::Mock.new
    validator_class.expect :build, return_validator, [schema, parent_schema]
    result = JSchema::Validator.stub :constants, [:Test] do
      JSchema::Validator.stub :const_get, validator_class do
        JSchema::Validator.build(schema, parent_schema)
      end
    end
    validator_class.verify
    result
  end
end
