# frozen_string_literal: true

module AssertionHelpers
  def assert_received(receiver, expected_message, expected_args = [])
    mock = MiniTest::Mock.new
    mock.expect(expected_message, nil, expected_args)

    receiver_stub = ->(*args) { mock.__send__(expected_message, *args) }
    receiver.stub(expected_message, receiver_stub) { yield if block_given? }

    mock.verify
  end
end
