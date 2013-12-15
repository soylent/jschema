require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'
require_relative 'schema_validation_helpers'

# rubocop:disable ClassLength
class TestProperties < Minitest::Test
  include Assertions
  include SchemaValidationHelpers

  def test_invalid_properties_argument
    keywords.each do |keyword|
      assert_raises(JSchema::InvalidSchema) do
        build_from_schema(keyword => 1)
      end
    end
  end

  def test_invalid_properties_schema_argument
    keywords.each do |keyword|
      assert_raises(JSchema::InvalidSchema) do
        build_from_schema(keyword => { 'test' => 1 })
      end
    end
  end

  def test_passing_properties_validation_by_sub_schema
    keywords.each do |keyword|
      assert_passing_validation keyword
    end
  end

  def test_failing_properties_validation_by_sub_schema
    keywords.each do |keyword|
      assert_failing_validation keyword
    end
  end

  def test_passing_validation_when_additional_properties_are_not_allowed
    assert validator_with_additional_properties.valid?('test' => 123)
  end

  def test_failing_validation_when_additional_properties_are_not_allowed
    refute validator_with_additional_properties.valid?(
      'test' => 123, 'additional' => 321)
  end

  def test_passing_validation_when_additional_properties_are_allowed
    validator = build_from_schema(
      'additionalProperties' => true,
      'properties' => { 'test' => {} }
    )

    assert validator.valid?('test' => 123, 'additional' => true)
  end

  def test_passing_validation_with_additional_and_pattern_properties
    validator = validator_with_additional_and_pattern_properties
    assert validator.valid?('test123' => true)
  end

  def test_failing_validation_with_additional_and_pattern_properties
    validator = validator_with_additional_and_pattern_properties
    refute validator.valid?('test' => true)
  end

  def test_passing_validation_when_any_properties_are_disallowed
    assert validator_with_disallowed_properties.valid?({})
  end

  def test_failing_validation_when_any_properties_are_disallowed
    refute validator_with_disallowed_properties.valid?('test' => 123)
  end

  def test_that_validation_always_passes_for_non_object_instances
    validator = build_from_schema('additionalProperties' => false)
    assert validator.valid?('test')
  end

  def test_building_validator_from_properties
    validator = build_from_schema('properties' => { 'test' => {} })
    assert_instance_of JSchema::Validator::Properties, validator
  end

  def test_building_validator_from_additional_properties
    validator = build_from_schema('additionalProperties' => false)
    assert_instance_of JSchema::Validator::Properties, validator
  end

  def test_building_validator_from_empty_schema
    assert_nil build_from_schema({})
  end

  private

  def validator_class
    JSchema::Validator::Properties
  end

  def keywords
    ['properties', 'patternProperties', 'additionalProperties']
  end

  def validator_with_additional_properties
    build_from_schema(
      'additionalProperties' => false,
      'properties' => { 'test' => {} }
    )
  end

  def validator_with_additional_and_pattern_properties
    build_from_schema(
      'additionalProperties' => false,
      'patternProperties' => { '\d+' => {} }
    )
  end

  def validator_with_disallowed_properties
    build_from_schema('additionalProperties' => false)
  end

  def assert_passing_validation(keyword)
    stub_schema_validations(true) do
      validator = build_from_schema(keyword => { 'test' => {} })
      assert validator.valid?('test' => 123)
    end
  end

  def assert_failing_validation(keyword)
    stub_schema_validations(false) do
      validator = build_from_schema(keyword => { 'test' => {} })
      refute validator.valid?('test' => 123)
    end
  end
end
