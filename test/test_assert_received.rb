require 'helper'
require 'support/assertion_helper'

class TestAssertReceived < Minitest::Test
  include AssertionHelper

  def test_message_sending_without_params
    assert_received(Object, :class) do
      Object.class
    end
  end

  def test_message_sending_with_params
    assert_received(String, :==, [Integer]) do
      String == Integer
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
      assert_received(String, :==, [Integer]) do
        String == TrueClass
      end
    end
  end
end
