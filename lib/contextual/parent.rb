# frozen_string_literal: true

require_relative '../test_failure'
require_relative '../test_neutral'
require_relative '../test_pass'

module Contextual
  # A Parent is a Node that can have children
  module Parent
    # @return [Array<Node>]
    attr_reader :children

    # @param children [Array<Node>]
    def set_parent(children = [])
      @children = children
      @test_fail_count = 0
      @test_success_count = 0
      @test_neutral_count = 0
      @filter_applies_to_children = false
      assign_children
    end

    def assign_parent(parent_options)
      super
      @children.each do |child|
        next unless child.respond_to?(:assign_parent)

        child.assign_parent(parent_options)
      end
    end

    def should_run_with_search_term_with_children(filter_settings)
      # Check if the general search term applies here
      return true if should_run_with_search_term(filter_settings)

      if filter_settings.has_test_filter_term ||
         filter_settings.has_test_search_for
        should_run_filter_on_children(filter_settings)
      end

      # No applicable filter
      true
    end

    def report_children(filter_settings)
      @children.each do |child|
        if @filter_applies_to_children
          child.report(filter_settings) if child.should_run_with_filter(filter_settings)
        else
          child.report(filter_settings)
        end
      end
    end

    def get_result(filter_settings)
      super

      # This is just a stub if there's no children - do nothing
      return TestNeutral.new(@title, 'Empty - no tests') if @children.empty?

      @result = run_setup

      return @result unless @result.nil?

      @result = get_result_children(filter_settings)

      teardown_failure = run_teardown
      @result = teardown_failure unless teardown_failure.nil?

      @result
    end

    def successes
      current_success_count = @test_success_count
      @children.each do |child|
        current_success_count += child.successes if child.instance_of? Group
      end
      current_success_count
    end

    def failures
      current_fail_count = @test_fail_count
      @children.each do |child|
        current_fail_count += child.failures if child.instance_of? Group
      end
      current_fail_count
    end

    def neutrals
      current_neutral_count = @test_neutral_count
      @children.each do |child|
        current_neutral_count += child.neutrals if child.instance_of? Group
      end
      current_neutral_count
    end

    def total
      test_count = 0
      @children.each do |child|
        if child.instance_of? Group
          test_count += child.total
        elsif child.instance_of?(Test) && child.ran_successfully
          test_count += 1
        end
      end
      test_count
    end

    def critical_inconclusive
      super
      @children.each do |child|
        child.critical_inconclusive
        @test_neutral_count += 1
      end
    end

    private

    def assign_children
      @children.each do |child|
        if child.respond_to?(:assign_parent)
          child.assign_parent(@options)
        else
          # Someone tried to add something that isn't a child into their test suite
          throw 'Only objects like Group or Test can be children of another node.'
        end
      end
    end

    def should_run_filter_on_children(filter_settings)
      @filter_applies_to_children = true
      @children.any? { |child| child.should_run_with_filter(filter_settings) }
    end

    def get_result_children(filter_settings)
      child_success_count = 0
      child_fail_count = 0
      @children.each do |child|
        result = get_result_child(filter_settings, child)
        next if result.nil?

        child_success_count += result.successes
        child_fail_count += result.failures

        next unless child.instance_of? Test

        @test_success_count += result.successes
        @test_fail_count += result.failures
        @test_neutral_count += result.neutrals
      end

      return TestFailure.new(@title, 'Some tests failed') if child_fail_count.positive?
      return TestNeutral.new(@title) if child_success_count.zero?

      TestPass.new(@title)
    end

    # @param filter_settings [FilterSettings]
    # @param child [Node]
    # @return [TestResult, nil]
    def get_result_child(filter_settings, child)
      return if @filter_applies_to_children && !child.should_run_with_filter(filter_settings)

      child.run(@context.dup, filter_settings)
    end
  end
end
