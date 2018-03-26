# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'
require 'support/schema_validation_helpers'
require 'support/shared/validation_against_schemas_tests'

class TestAllOf < Minitest::Test
  include ValidatorAssertionHelpers
  include SchemaValidationHelpers
  include ValidationAgainstSchemasTests

  def test_passing_validation_against_schemas
    stub_schema_validations(true, true) do
      assert validator([generate_schema, generate_schema]).valid?('test')
    end
  end

  def test_failing_validation_against_schemas
    stub_schema_validations(false, true) do
      refute validator([generate_schema, generate_schema]).valid?('test')
    end
  end

  private

  def validator_class
    JSchema::Validator::AllOf
  end
end
