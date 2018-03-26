# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'
require 'support/schema_validation_helpers'

class TestItems < Minitest::Test
  include ValidatorAssertionHelpers
  include SchemaValidationHelpers

  def test_that_additional_items_must_be_boolean_or_schema
    assert_raises_unless 'additionalItems', :boolean, :object
  end

  def test_that_additional_items_accepts_only_valid_schema
    assert_raises_unless_schema 'additionalItems'
  end

  def test_that_items_must_be_object_or_array
    assert_raises_unless 'items', :object, :array
  end

  def test_that_items_must_be_a_valid_schema
    assert_raises_unless_schema 'items'
  end

  def test_that_items_must_be_schema_array
    assert_raises_unless_schema_array 'items'
  end

  def test_default_value_for_items
    validator = build_from_schema('additionalItems' => false)
    assert validator.valid? [1, 2, 3]
  end

  def test_passing_validation_by_items_schema
    stub_schema_validations(true) do
      assert build_from_schema('items' => {}).valid?(['test'])
    end
  end

  def test_passing_validation_by_items_schema_array
    basic_schema = generate_schema
    stub_schema_validations(true) do
      schema = { 'items' => [basic_schema, basic_schema] }
      assert build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  def test_passing_validation_by_items_when_additional_items_is_omitted
    stub_schema_validations(true) do
      schema = { 'items' => [generate_schema] }
      assert build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  def test_passing_validation_by_items_and_additional_items
    stub_schema_validations(true) do
      schema = {
        'items' => [generate_schema],
        'additionalItems' => generate_schema
      }
      assert build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  def test_passing_validation_when_additional_items_are_not_allowed
    stub_schema_validations(true) do
      schema = {
        'items' => [generate_schema],
        'additionalItems' => false
      }
      assert build_from_schema(schema).valid?(['test'])
    end
  end

  def test_passing_validation_when_instance_size_is_less_than_items_size
    stub_schema_validations(true) do
      schema = {
        'items' => [generate_schema, generate_schema],
        'additionalItems' => false
      }
      assert build_from_schema(schema).valid?(['test'])
    end
  end

  def test_failing_validation_when_additional_items_are_not_allowed
    stub_schema_validations(true) do
      schema = {
        'items' => [generate_schema],
        'additionalItems' => false
      }
      refute build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  def test_failing_validation_by_items_schema_array
    stub_schema_validations(false, true) do
      schema = { 'items' => [generate_schema, generate_schema] }
      refute build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  def test_failing_validation_by_additional_items_schema
    stub_schema_validations(true, false) do
      schema = {
        'items' => [generate_schema],
        'additionalItems' => generate_schema
      }
      refute build_from_schema(schema).valid?(['test', 'test'])
    end
  end

  private

  def validator_class
    JSchema::Validator::Items
  end
end
