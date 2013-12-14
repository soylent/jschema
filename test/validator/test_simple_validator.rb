require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'

class TestSimpleValidator < MiniTest::Unit::TestCase
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

      def valid_instance?(param)
      end

      def applicable_types
        [String]
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
    end
  end

  def test_failing_validation
    stub_validator nil, false do |vdr|
      refute vdr.valid?('instance')
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
    stub_validator [Fixnum], false do |vdr|
      assert vdr.valid?('instance')
    end
  end

  def test_applicable_types
    stub_validator [Fixnum], false do |vdr|
      refute vdr.valid?(0)
    end
  end

  private

  def stub_validator(applicable_types, validation_result)
    validator_example = validator 'test'
    validator_example.stub :applicable_types, applicable_types do
      validator_example.stub :valid_instance?, validation_result do
        yield validator_example
      end
    end
  end

  def validator_class
    @validator_class
  end
end
