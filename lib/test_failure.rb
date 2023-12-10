# frozen_string_literal: true

require_relative 'test_result'
require_relative 'helpers/printer'

# Test that has failed, either with a provided message or thrown error
class TestFailure < TestResult
  def initialize(title, message = nil, err = nil)
    super(title)
    @message = message
    @err = err
  end

  def report(spacer_count = 0)
    super
    Printer.fail(@spacer + format_message)
    return if @err.nil?

    # Extra space is to compensate for the [X]
    Printer.fail("#{@spacer}    #{@err}")

    # Mimic the default Ruby trace. This does not need additional formatting as
    # some terminals recognize this as a stack trace.
    puts @err.backtrace.join("\n\t")
             .sub("\n\t", ": #{@err}#{@err.class ? " (#{@err.class})" : ''}\n\t")
  end

  def failures
    1
  end

  private

  def format_message
    if @title.nil?
      "    #{@message}"
    else
      "[X] #{@title}: #{@message}"
    end
  end
end

# Assert that has failed with a message explaining why the assertion failed
class AssertFailure < AssertResult
  def initialize(message)
    super(message, nil)
  end

  def report(spacer_count)
    super

    Printer.fail(@spacer + format_message)
  end
end
