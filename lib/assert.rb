class AssertionException < RuntimeError
end

module Assertions
  def assert_equal(expected, actual, message_prefix = nil)
    message_prefix << ': ' if message_prefix
    message_prefix ||= ''
    message = "#{message_prefix}#{expected} expected but was #{actual}" unless message
    assert(expected != actual, message, 1)
  end

  def assert(result, message, stack_pos = 0)
    return nil unless result
    exc = AssertionException.new(message)
    exc.set_backtrace(caller[stack_pos..])
    raise exc
  end
end

class Object
  include Assertions
end
