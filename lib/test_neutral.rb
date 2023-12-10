# frozen_string_literal: true

require_relative 'test_result'

class TestNeutral < TestResult

  def initialize(title, message = nil)
    super(title)
    @message = message
  end

  def report(spacer_count = 0)
    super
    if @message.nil?
      Printer.neutral("#{@spacer}(-) #{@title}")
    else
      Printer.neutral("#{@spacer}    #{@title}: #{@message}")
    end
  end

  def neutrals
    1
  end
end

class AssertNeutral < AssertResult
  def report(spacer_count)
    super
    Printer.neutral(@spacer + format_message)
  end
end