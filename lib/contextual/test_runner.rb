# frozen_string_literal: true

require_relative '../helpers/filter_settings'
require_relative '../helpers/printer'
require_relative 'node'
require_relative 'parent'

# TestRunner
#
# @param title
# @param context_builder
# @param children
# @param options
# @param skip
#
# The root node for any tests. Automatically runs once created. Do not include
# TestRunners inside other Groups.
class TestRunner < Contextual::Node
  include Contextual::Parent

  def initialize(
    title,
    children = [],
    setup: nil,
    teardown: nil,
    options: nil,
    skip: false
  )
    super(title, setup: setup, teardown: teardown, options: options, skip: skip)
    set_parent(children)
    # TODO: Fetch filter settings
    @filter_settings = FilterSettings.new
    run_all
  end

  private

  def run_all
    return if skip

    return unless should_run_with_filter(@filter_settings)

    run(@context, @filter_settings)
    report(@filter_settings)
  end

  # @param filter_settings [FilterSettings]
  def should_run_with_filter(filter_settings)
    return @title == filter_settings.test_runner_search_for if filter_settings.has_test_runner_search_for
    return @title.include? filter_settings.test_runner_filter_term if filter_settings.has_test_runner_filter_term

    should_run_with_search_term_with_children(filter_settings)
    true
  end

  def report(filter_settings)
    @result.report
    return if @skip

    report_children(filter_settings)

    # Get count of successes, failures, and neutrals
    message = Printer.summary(total, successes, failures, neutrals)

    Printer.pass(message) if @result.instance_of? TestPass

    Printer.fail(message) if @result.instance_of? TestFailure

    Printer.neutral(message) if @result.instance_of? TestNeutral
  end
end
