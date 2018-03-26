# frozen_string_literal: true

require_relative 'argument_is_array_of_schemas_tests'

module ValidationAgainstSchemasTests
  include SchemaValidationHelpers
  include ArgumentIsArrayOfSchemasTests

  def test_passing_validation_against_one_schema
    stub_schema_validations(true) do
      assert validator([generate_schema]).valid?('test')
    end
  end

  def test_failing_validation_against_one_schema
    stub_schema_validations(false) do
      refute validator([generate_schema]).valid?('test')
    end
  end

  def test_failing_validation_all_validations_fail
    stub_schema_validations(false, false) do
      refute validator([generate_schema, generate_schema]).valid?('test')
    end
  end
end
