require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'

class TestSimpleValidator < Minitest::Test
  include Assertions

  def setup
    super
    @validator_class = Class.new(JSchema::SimpleValidator) do
      private

      self.keywords = ['param']

      def validate_args(param)
        true
      end

      def post_initialize(param)
      end

      def validate_instance(param)
      end

      def applicable_type
        String
      end
    end
  end

  def test_parent_attribute
    parent = Object.new
    example = @validator_class.new('param', parent)
    assert_equal parent, example.parent
  end

  def test_building_from_schema
    validator_example = build_from_schema('param' => 'test')
    assert_instance_of validator_class, validator_example
  end

  def test_building_from_empty_schema
    assert_nil build_from_schema
  end

  def test_passing_validation
    stub_validator nil, true do |vdr|
      assert vdr.valid?('instance')
      assert_nil vdr.validate('instance')
    end
  end

  def test_failing_validation
    stub_validator nil, false do |vdr|
      refute vdr.valid?('instance')
      assert_equal 'error', vdr.validate('instance')
    end
  end

  def test_invalid_params
    assert_raises(JSchema::InvalidSchema) do
      Class.new(JSchema::SimpleValidator) do
        private

        def validate_args
          false
        end
      end.new('test')
    end
  end

  def test_that_validation_always_passes_if_validator_is_not_applicable
    stub_validator Integer, false do |vdr|
      assert vdr.valid?('instance')
    end
  end

  def test_failing_validation_when_validator_is_applicable
    stub_validator Integer, false do |vdr|
      refute vdr.valid?(0)
    end
  end

  def test_failing_validation_when_instance_is_descendant_of_applicable_type
    stub_validator Hash, false do |vdr|
      descendant_type = Class.new(Hash)
      refute vdr.valid?(descendant_type.new)
    end
  end

  private

  def stub_validator(applicable_type, valid)
    validator_example = validator 'test'
    validation_result = valid ? nil : 'error'
    validator_example.stub :applicable_type, applicable_type do
      validator_example.stub :validate_instance, validation_result do
        yield validator_example
      end
    end
  end

  def validator_class
    @validator_class
  end
end
