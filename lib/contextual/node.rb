# frozen_string_literal: true

require_relative '../test_options'

module Contextual
  # @abstract Base class for testing nodes, like TestRunner, Group, and Test.
  class Node
    attr_reader :skip, :result

    def initialize(title, setup: nil, teardown: nil, options: nil, skip: false)
      @title = title
      @setup = setup
      @teardown = teardown
      @options = options.nil? ? TestOptions.new : options
      @skip = skip
      @context = Context.new
    end

    # @param current_context [Context] Parent or root context
    # @param filter_settings [FilterSettings]
    # @return [TestResult]
    def run(current_context, filter_settings)
      if @skip
        @result = TestNeutral.new(@title, 'Skipped')
      else
        @context.apply(current_context)
        @result = get_result(filter_settings)
      end
      @result
    end

    # Runs the setup hook
    # @return [TestResult, Nil] Returns a TestFailure if the setup fails
    def run_setup
      return if @setup.nil?

      begin
        @setup.call(@context)
        nil
      rescue StandardError => e
        @result = TestFailure.new(@title, 'Failed during setup', e)
      end
    end

    # Runs the teardown hook
    # @return [TestResult, Nil] Returns a TestFailure if the teardown fails
    def run_teardown
      return if @teardown.nil?

      begin
        @teardown.call(@context)
        nil
      rescue StandardError => e
        if @result.successes.positive?
          TestFailure.new(@title, 'Tests passed, but failed during teardown.', e)
        else
          TestFailure.new(@title, 'Failed during teardown', e)
        end
      end
    end

    # @abstract Override this method in your subclass
    # @param _filter_settings [FilterSettings] not used
    # @return [TestResult]
    def get_result(_filter_settings)
      # This has been marked as skipped - do nothing
      TestNeutral.new(@title, 'Skipped') if @skip
    end

    # Should this run with the current filter settings, checking general search
    # @param filter_settings [FilterSettings]
    # @return [Boolean]
    def should_run_with_search_term(filter_settings)
      # Check if the general search term applies here
      return @title.include?(filter_settings.general_search_term) if filter_settings.has_general_search_term

      true
    end
  end
end
