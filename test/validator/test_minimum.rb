# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'

class TestMinimum < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_minimum_is_a_number
    assert_raises_unless 'minimum', :integer, :number
  end

  def test_that_exclusive_minimum_is_boolean
    assert_raises(JSchema::InvalidSchema) do
      build_from_schema('minimum' => 1, 'exclusiveMinimum' => 0)
    end
  end

  def test_that_exclusive_minimum_can_not_be_specified_without_minimum
    assert_raises(JSchema::InvalidSchema) do
      build_from_schema('exclusiveMinimum' => false)
    end
  end

  def test_passing_validation_when_exclusive_minimum_is_not_specified
    assert build_from_schema('minimum' => 1).valid?(2)
  end

  def test_passing_validation_when_exclusive_minimum_is_false
    schema = build_from_schema('minimum' => 2, 'exclusiveMinimum' => false)
    assert schema.valid?(2)
  end

  def test_passing_validation_when_exclusive_minimum_is_true
    schema = build_from_schema('minimum' => 1, 'exclusiveMinimum' => true)
    assert schema.valid?(2)
  end

  def test_failing_validation_when_exclusive_minumum_is_not_specified
    refute build_from_schema('minimum' => 2).valid?(1)
  end

  def test_failing_validation_when_exclusive_minimum_is_false
    schema = build_from_schema('minimum' => 2, 'exclusiveMinimum' => false)
    refute schema.valid?(1)
  end

  def test_failing_validation_when_exclusive_minimum_is_true
    schema = build_from_schema('minimum' => 1, 'exclusiveMinimum' => true)
    refute schema.valid?(1)
  end

  private

  def validator_class
    JSchema::Validator::Minimum
  end
end
