require 'minitest/autorun'
require 'jschema'

require_relative 'assertions'

class TestMaximum < MiniTest::Unit::TestCase
  include Assertions

  def test_that_maximum_is_a_number
    assert_raises_unless 'maximum', :integer, :number
  end

  def test_that_exclusive_maximum_is_boolean
    assert_raises(JSchema::InvalidSchema) do
      build_from_schema('maximum' => 1, 'exclusiveMaximum' => 0)
    end
  end

  def test_that_exclusive_maximum_can_not_be_specified_without_maximum
    assert_raises(JSchema::InvalidSchema) do
      build_from_schema('exclusiveMaximum' => false)
    end
  end

  def test_passing_validation_when_exclusive_maximum_is_not_specified
    assert build_from_schema('maximum' => 3).valid?(2)
  end

  def test_passing_validation_when_exclusive_maximum_is_false
    schema = build_from_schema('maximum' => 2, 'exclusiveMaximum' => false)
    assert schema.valid?(2)
  end

  def test_passing_validation_when_exclusive_maximum_is_true
    schema = build_from_schema('maximum' => 3, 'exclusiveMaximum' => true)
    assert schema.valid?(2)
  end

  def test_failing_validation_when_exclusive_maximum_is_not_specified
    refute build_from_schema('maximum' => 1).valid?(2)
  end

  def test_failing_validation_when_exclusive_maximum_is_false
    schema = build_from_schema('maximum' => 1, 'exclusiveMaximum' => false)
    refute schema.valid?(2)
  end

  def test_failing_validation_when_exclusive_maximum_is_true
    schema = build_from_schema('maximum' => 1, 'exclusiveMaximum' => true)
    refute schema.valid?(1)
  end

  private

  def validator_class
    JSchema::Validator::Maximum
  end
end
