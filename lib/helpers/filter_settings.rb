# frozen_string_literal: true

# Holds a collection of filter settings. Filter settings are normally set via
# the command line as flag options.
class FilterSettings
  def initialize(
    general_search_term: nil,
    test_filter_term: nil,
    test_search_for: nil,
    group_filter_term: nil,
    group_search_for: nil,
    test_runner_filter_term: nil,
    test_runner_search_for: nil
  )
    @general_search_term = general_search_term || get_from_args(FilterProps::GENERAL_SEARCH_TERM)
    @test_filter_term = test_filter_term || get_from_args(FilterProps::TEST_FILTER_TERM)
    @test_search_for = test_search_for || get_from_args(FilterProps::TEST_SEARCH_FOR)
    @group_filter_term = group_filter_term || get_from_args(FilterProps::GROUP_FILTER_TERM)
    @group_search_for = group_search_for || get_from_args(FilterProps::GROUP_SEARCH_FOR)
    @test_runner_filter_term = test_runner_filter_term || get_from_args(FilterProps::TEST_RUNNER_FILTER_TERM)
    @test_runner_search_for = test_runner_search_for || get_from_args(FilterProps::TEST_RUNNER_SEARCH_FOR)
  end

  def has_general_search_term
    !@general_search_term.nil? && @general_search_term.length.positive?
  end

  def has_test_filter_term
    !@test_filter_term.nil? && @test_filter_term.length.positive?
  end

  def has_test_search_for
    !@test_search_for.nil? && @test_search_for.length.positive?
  end

  def has_group_filter_term
    !@group_filter_term.nil? && @group_filter_term.length.positive?
  end

  def has_group_search_for
    !@group_search_for.nil? && @group_search_for.length.positive?
  end

  def has_test_runner_filter_term
    !@test_runner_filter_term.nil? && @test_runner_filter_term.length.positive?
  end

  def has_test_runner_search_for
    !@test_runner_search_for.nil? && @test_runner_search_for.length.positive?
  end

  def is_not_empty
    hasGeneralSearchTerm ||
      hasTestFilterTerm ||
      hasTestSearchFor ||
      hasGroupFilterTerm ||
      hasGroupSearchFor ||
      hasTestRunnerFilterTerm ||
      hasTestRunnerSearchFor
  end

  def to_properties
    props = []

    props << [FilterProps::GENERAL_SEARCH_TERM, @general_search_term] if has_general_search_term
    props << [FilterProps::TEST_FILTER_TERM, @test_filter_term] if has_test_filter_term
    props << [FilterProps::TEST_SEARCH_FOR, @test_search_for] if has_test_search_for
    props << [FilterProps::GROUP_FILTER_TERM, @group_filter_term] if has_group_filter_term
    props << [FilterProps::GROUP_SEARCH_FOR, @group_search_for] if has_group_search_for
    props << [FilterProps::TEST_RUNNER_FILTER_TERM, @test_runner_filter_term] if has_test_runner_filter_term
    props << [FilterProps::TEST_RUNNER_SEARCH_FOR, @test_runner_search_for] if has_test_runner_search_for

    props
  end

  # @param [String] flag
  # @return [String, Nil]
  def get_from_args(flag)
    index = ARGV.find_index(flag)
    return ARGV[index + 1] if index && index != ARGV.length - 1

    nil
  end
end

module FilterProps
  GENERAL_SEARCH_TERM = 'generalSearchTerm'
  TEST_FILTER_TERM = 'testFilterTerm'
  TEST_SEARCH_FOR = 'testSearchFor'
  GROUP_FILTER_TERM = 'groupFilterTerm'
  GROUP_SEARCH_FOR = 'groupSearchFor'
  TEST_RUNNER_FILTER_TERM = 'testRunnerFilterTerm'
  TEST_RUNNER_SEARCH_FOR = 'testRunnerSearchFor'
end
