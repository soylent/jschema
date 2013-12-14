require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'
require_relative 'schema_validation_helpers'
require_relative 'validation_against_schemata_tests'

class TestAnyOf < MiniTest::Unit::TestCase
  include Assertions
  include SchemaValidationHelpers
  include ValidationAgainstSchemataTests

  def test_passing_validation_agaist_schemata
    stub_schema_validations(true, false, true) do
      schema = [generate_schema, generate_schema, generate_schema]
      assert validator(schema).valid?('test')
    end
  end

  def test_failing_validation_against_schemata
    stub_schema_validations(false, false) do
      refute validator([generate_schema, generate_schema]).valid?('test')
    end
  end

  private

  def validator_class
    JSchema::Validator::AnyOf
  end
end
