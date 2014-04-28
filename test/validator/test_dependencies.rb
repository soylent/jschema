require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'
require_relative 'schema_validation_helpers'

class TestDependencies < Minitest::Test
  include Assertions
  include SchemaValidationHelpers

  def test_that_argument_is_an_object
    assert_raises_unless 'dependencies', :object
  end

  def test_that_each_value_of_argument_object_is_either_an_object_or_an_array
    assert_raises(JSchema::InvalidSchema) do
      validator('test' => 0)
    end
  end

  def test_that_property_dependency_has_at_least_one_element
    assert_raises(JSchema::InvalidSchema) do
      validator('test' => [])
    end
  end

  def test_that_property_dependency_includes_only_strings
    assert_raises(JSchema::InvalidSchema) do
      validator('test' => [0])
    end
  end

  def test_that_property_dependency_containt_uniq_elements
    assert_raises(JSchema::InvalidSchema) do
      validator('test' => ['property', 'property'])
    end
  end

  def test_that_argument_can_contain_schema_and_property_dependencies
    validator('schema_dependency' => {}, 'property_dependency' => ['test'])
  end

  def test_passing_schema_dependency_validation
    stub_schema_validations(true) do
      assert schema_dependencies_validator.valid?('test' => 0)
    end
  end

  def test_failing_schema_dependency_validation
    stub_schema_validations(false) do
      refute schema_dependencies_validator.valid?('test' => 0)
    end
  end

  def test_passing_validation_when_instance_has_no_dependencies
    stub_schema_validations(false) do
      assert schema_dependencies_validator.valid?('other' => 0)
    end
  end

  def test_passing_property_dependency_validation
    expect_required_validation(true) do
      assert property_dependencies_validator.valid?('test' => 0)
    end
  end

  def test_failing_property_dependency_validation
    expect_required_validation(false) do
      refute property_dependencies_validator.valid?('test' => 0)
    end
  end

  def test_passing_property_dependency_validation_no_dependencies
    expect_required_validation(false) do
      assert property_dependencies_validator.valid?('other' => 0)
    end
  end

  private

  def validator_class
    JSchema::Validator::Dependencies
  end

  def schema_dependencies_validator
    validator('test' => {})
  end

  def property_dependencies_validator
    validator('test' => ['required_property'])
  end

  def expect_required_validation(valid)
    validator_stub =
      Struct.new(:valid) do
        def validate(_)
          'error' unless valid
        end
      end

    validator = validator_stub.new(valid)
    JSchema::Validator::Required.stub :new, validator do
      yield
    end
  end
end
