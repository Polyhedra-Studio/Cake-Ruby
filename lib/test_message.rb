# frozen_string_literal: true

require_relative 'test_result'
require_relative 'helpers/printer'

# Prints system messages, generally ran by the CLI runner
class TestMessage < TestResult
  attr_accessor :message

  def initialize(title, message)
    super(title)
    @message = message
  end

  def report(spacer_count = 0)
    super
    if message.nil?
      Printer.neutral(@spacer + @title)
    else
      Printer.neutral("#{@spacer}#{@title} #{@message}")
    end
  end
end
