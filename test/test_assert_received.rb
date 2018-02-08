require 'helper'
require 'support/assertion_helpers'

class TestAssertReceived < Minitest::Test
  include AssertionHelpers

  def test_message_sending_without_params
    obj = Object.new

    assert_received(obj, :class) { obj.class }
  end

  def test_assertion_failure_when_message_is_not_received
    obj = Object.new

    assert_raises(MockExpectationError) { assert_received(obj, :class) }
  end

  def test_assertion_failure_when_unexpected_message_is_received
    obj = Object.new

    assert_raises(MockExpectationError) do
      assert_received(obj, :clone) { obj.dup }
    end
  end

  def test_message_sending_with_params
    obj = Object.new
    other_obj = Object.new

    assert_received(obj, :==, [other_obj]) { obj == other_obj }
  end

  def test_assertion_failure_when_unexpected_params_are_received
    obj = Object.new
    other_obj = Object.new

    assert_raises(MockExpectationError) do
      assert_received(obj, :==, [true]) { obj == other_obj }
    end
  end
end
