# frozen_string_literal: true

require_relative '../lib/helpers/printer'

# Collector holds totals for all collectors and prints a summary
class Collector
  # @return [Integer]
  attr_reader :total, :end_index

  def initialize
    @collectors = []
    @total = 0
    @successes = 0
    @failures = 0
    @neutrals = 0
    @end_index = 0
  end

  # Adds a collector and updates the total, successes, failures, and neutrals
  # @param collector [TestRunnerCollector]
  def add_collector(collector)
    @collectors << collector
    @total += collector.total
    @successes += collector.successes
    @failures += collector.failures
    @neutrals += collector.neutrals
    @end_index = collector.end_index
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

# TestRunnerCollector holds totals for a single test runner
class Test_Runner_Controller
  # @return [Integer]
  attr_reader :total
  # @return [Integer]
  attr_reader :successes
  # @return [Integer]
  attr_reader :failures
  # @return [Integer]
  attr_reader :neutrals
  # @return [Integer]
  attr_reader :end_index

  # Initializes a new instance of the class.
  #
  # @param output [Array<String>] Total output of the TestRunner
  # @param total [Integer] Total amount of tests from the TestRunner
  # @param successes [Integer] Total amount of successes from the TestRunner
  # @param failures [Integer] Total amount of failures from the TestRunner
  # @param neutrals [Integer] Total amount of neutrals from the TestRunner
  # @param end_index [Integer] Last line given by the TestRunner
  def initialize(output, total:, successes:, failures:, neutrals:, end_index:)
    @output = output
    @total = total
    @successes = successes
    @failures = failures
    @neutrals = neutrals
    @end_index = end_index
  end

  def print_message
    # This already has formatting from the printer, just pass through the original message
    @output.each do |message|
      puts message
    end
  end

  def print_errors
    return unless @failures.positive?

    print_message
  end
end
