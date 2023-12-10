# frozen_string_literal: true

require_relative '../test_failure'
require_relative '../test_neutral'
require_relative '../test_pass'
require_relative 'context'
require_relative 'node'
require_relative 'child'

# A Test is an actionable unit of testing.
class Test < Contextual::Node
  include Contextual::Child
  attr_reader :ran_successfully

  # @param title [String]
  # @param assertions [Proc]
  # @param action [Proc]
  # @param skip [Boolean]
  # @param options [TestOptions]
  def initialize(
    title,
    assertions:,
    setup: nil,
    teardown: nil,
    action: nil,
    options: nil,
    skip: false
  )
    super(title, setup: setup, teardown: teardown, options: options, skip: skip)
    @action = action
    @assertions = assertions
    @assert_failures = []
  end

  def ran_successfully=(value)
    # Once this has failed, don't allow it to recover
    return if @ran_successfully == false

    @ran_successfully = value
  end

  def should_run_with_filter(filter_settings)
    return filter_settings.testSearchFor == _title if filter_settings.hasTestSearchFor
    return _title.include? filter_settings.testFilterTerm if filter_settings.hasTestFilterTerm

    should_run_with_search_term(filter_settings)
  end

  def report(*)
    @result.report(@parent_count)

    @assert_failures.each do |assert_failure|
      assert_failure.report(@parent_count)
    end
  end

  def get_result(filter_settings)
    super

    @result = run_setup

    unless @result.nil?
      # Setup failed, we want to bail out as soon as possible
      @ran_successfully = false
      return @result
    end

    run_action

    run_assertions

    teardown_failure = run_teardown
    unless teardown_failure.nil?
      @ran_successfully = false
      @result = teardown_failure
    end

    # At this point, if nothing has failed, this test ran successfully
    @ran_successfully = true if @ran_successfully.nil?
    @result
  end

  private

  def run_action
    return if @action.nil?

    begin
      value = @action.call(@context)
      @context.actual = value unless value.nil?
    rescue StandardError => e
      @ran_successfully = false
      # We want to continue and try to teardown anything we've set up
      # even if it's all haywire at this point
      @result = TestFailure.new(@title, 'Failed during action', e)
    end
  end

  def run_assertions
    # Don't bother running assertions if we've already come up failed
    return unless @result.nil?

    asserts = @assertions.call(@context)
    has_failed_a_test = false
    assert_result = nil

    asserts.each_with_index do |expect, index|
      # Skip rest of assertions if an assert has failed already,
      # allowing a bypass with an option flag.
      if has_failed_a_test && @options.fail_on_first_expect
        assert_result = AssertNeutral.new(
          'Skipped: Previous assert failed.',
          index
        )
        @assert_failures << assert_result
        next
      end

      begin
        assert_result = expect.run
      rescue StandardError => e
        assert_result = TestFailure.new(
          @title,
          'Failed while running assertions',
          e
        )
      end

      next unless assert_result.instance_of? AssertFailure

      assert_result.index = index if asserts.length > 1
      @assert_failures << assert_result
      has_failed_a_test = true
    end

    @result = if @assert_failures.empty?
                TestPass.new(@title)
              else
                TestFailure.new(@title, 'Assert failed.')
              end
  end
end
