# frozen_string_literal: true

require 'helper'

require 'support/validator_assertion_helpers'

class TestType < Minitest::Test
  include ValidatorAssertionHelpers

  def test_that_argument_is_a_string_or_an_array
    assert_raises_unless 'type', :string, :array
  end

  def test_that_argument_is_a_unique_string_array
    assert_raises_unless_string_array 'type'
  end

  def test_passing_string_validation
    assert validator('string').valid?('str')
  end

  def test_failing_string_validation
    refute validator('string').valid?(1)
  end

  def test_passing_integer_validation
    assert validator('integer').valid?(1)
    assert validator('integer').valid?(2**64)
  end

  def test_failing_integer_validation
    refute validator('integer').valid?('str')
  end

  def test_passing_array_validation
    assert validator('array').valid?([])
  end

  def test_failing_array_validation
    refute validator('array').valid?('str')
  end

  def test_passing_boolean_validation
    assert validator('boolean').valid?(true)
    assert validator('boolean').valid?(false)
  end

  def test_failing_boolean_validation
    refute validator('boolean').valid?(nil)
    refute validator('boolean').valid?(0)
  end

  def test_passing_null_validation
    assert validator('null').valid?(nil)
  end

  def test_failing_null_validation
    refute validator('null').valid?(false)
    refute validator('null').valid?('')
  end

  def test_passing_object_validation
    assert validator('object').valid?('test' => 123)
  end

  def test_failing_object_validation
    refute validator('object').valid?([])
  end

  def test_passing_number_validation
    assert validator('number').valid?(1)
    assert validator('number').valid?(1.2)
    assert validator('number').valid?(BigDecimal('1.2'))
    assert validator('number').valid?(2**64)
  end

  def test_failing_number_validation
    refute validator('number').valid?('1')
  end

  def test_passing_multiple_type_validation
    mvalidator = validator %w[string null]
    assert mvalidator.valid?('str')
    assert mvalidator.valid?(nil)
  end

  def test_failing_multiple_type_validation
    mvalidator = validator %w[string null]
    refute mvalidator.valid?(1)
    refute mvalidator.valid?(false)
  end

  private

  def validator_class
    JSchema::Validator::Type
  end
end
