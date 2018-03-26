# frozen_string_literal: true

module PropertiesLimitTests
  def test_that_argument_is_an_integer
    assert_raises(JSchema::InvalidSchema) { validator 'string' }
  end

  def test_that_argument_can_be_big_integer
    validator 2**64
  end

  def test_that_argument_is_not_negative
    assert_raises(JSchema::InvalidSchema) { validator(-1) }
  end
end
