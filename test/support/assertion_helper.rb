module AssertionHelper
  def assert_received(receiver, message, args = [])
    mock = MiniTest::Mock.new
    mock.expect(message, nil, args)
    receiver_stub = ->(*arg) { mock.__send__ message, *arg }

    receiver.stub message, receiver_stub do
      yield if block_given?
    end

    mock.verify
  end
end
