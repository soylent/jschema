require 'minitest/autorun'
require_relative 'assert_received'

class TestAssertReceived < Minitest::Test
  def test_message_sending_without_params
    assert_received(Object, :class) do
      Object.class
    end
  end

  def test_message_sending_with_params
    assert_received(String, :==, Fixnum) do
      String == Fixnum
    end
  end

  def test_assertion_failure_when_message_is_not_received
    assert_raises(MockExpectationError) do
      assert_received(String, :class) do
      end
    end
  end

  def test_assertion_failure_when_unexpected_message_is_received
    assert_raises(MockExpectationError) do
      assert_received(String, :class) do
        String.name
      end
    end
  end

  def test_assertion_failure_when_unexpected_params_are_received
    assert_raises(MockExpectationError) do
      assert_received(String, :==, Fixnum) do
        String == Bignum
      end
    end
  end
end
