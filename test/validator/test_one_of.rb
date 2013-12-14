require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'
require_relative 'schema_validation_helpers'
require_relative 'validation_against_schemas_tests'

class TestOneOf < MiniTest::Unit::TestCase
  include Assertions
  include SchemaValidationHelpers
  include ValidationAgainstSchemasTests

  def test_passing_validation_against_schemas
    stub_schema_validations(true, false, false) do
      schemas = [generate_schema, generate_schema, generate_schema]
      assert validator(schemas).valid?('test')
    end
  end

  def test_failing_validation_when_more_than_one_validation_passes
    stub_schema_validations(true) do
      refute validator([generate_schema, generate_schema]).valid?('test')
    end
  end

  private

  def validator_class
    JSchema::Validator::OneOf
  end
end
