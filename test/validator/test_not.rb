# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'
require 'support/schema_validation_helpers'

class TestNot < Minitest::Test
  include ValidatorAssertionHelpers
  include SchemaValidationHelpers

  def test_that_argument_is_schema
    assert_raises_unless_schema 'not'
  end

  def test_passing_validation
    stub_schema_validations(false) do
      assert validator({}).valid?('test')
    end
  end

  def test_failing_validation
    stub_schema_validations(true) do
      refute validator({}).valid?('test')
    end
  end

  private

  def validator_class
    JSchema::Validator::Not
  end
end
