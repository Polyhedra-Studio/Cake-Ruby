# frozen_string_literal: true

require_relative '../lib/helpers/printer'

# Collector controls stdin and stdout
class Collector
  def initialize
    @collectors = []
    @total = 0
    @successes = 0
    @failures = 0
    @neutrals = 0
  end

  # Adds a collector and updates the total, successes, failures, and neutrals
  # @param collector (TestRunnerCollector)
  def add_collector(collector)
    @collectors << collector
    @total += collector.total
    @successes += collector.successes
    @failures += collector.failures
    @neutrals += collector.neutrals
  end

  def print_message(verbose)
    summary = Printer.summary(@total, @successes, @failures, @neutrals)

    if @failures.positive?
      Printer.fail(summary)
      @collectors.each(&:print_errors)
    elsif @successes.zero?
      Printer.neutral(summary)
    else
      Printer.pass(summary)
    end

    return unless verbose

    @collectors.each(&:print_message)
  end
end

class Test_Runner_Controller
  def initialize(output, summary, total:, successes:, failures:, neutrals:, end_index:)
    @output = output
    @summary = summary
    @total = total
    @successes = successes
    @failures = failures
    @neutrals = neutrals
    @end_index = end_index
  end

  def print_message
    # This already has formatting from the printer, just pass through the original message
    output.each do |message|
      puts message
    end
  end

  def print_errors
    return unless @failures.positive?

    print_message
  end
end
