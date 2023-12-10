# frozen_string_literal: true

require_relative 'test_result'

# A successful test result
class TestPass < TestResult
  def report(spacer_count = 0)
    super

    Printer.pass("#{@spacer}(O) #{@title}")
  end

  def successes
    1
  end
end

# A successful assertion result
class AssertPass < AssertResult
  def initialize
    super(nil)
  end
end
