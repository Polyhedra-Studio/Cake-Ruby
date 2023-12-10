# frozen_string_literal: true

# Holds a collection of filter settings. Filter settings are normally set via
# the command line as flag options.
class FilterSettings
  # attr_reader(
  #   :general_search_term,
  #   :test_filter_term,
  #   :test_search_for,
  #   :group_filter_term,
  #   :group_search_for,
  #   :test_runner_filter_term,
  #   :test_runner_search_for,
  # )

  attr_reader :test_runner_search_for

  FILTER_SETTING_PROPS = %w[
    generalSearchTerm
    testFilterTerm
    testSearchFor
    groupFilterTerm
    groupSearchFor
    testRunnerFilterTerm
    testRunnerSearchFor
  ].freeze

  def initialize(
    general_search_term: nil,
    test_filter_term: nil,
    test_search_for: nil,
    group_filter_term: nil,
    group_search_for: nil,
    test_runner_filter_term: nil,
    test_runner_search_for: nil
  )
    @general_search_term = general_search_term
    @test_filter_term = test_filter_term
    @test_search_for = test_search_for
    @group_filter_term = group_filter_term
    @group_search_for = group_search_for
    @test_runner_filter_term = test_runner_filter_term
    @test_runner_search_for = test_runner_search_for
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
    []
  end

  private

  def build_arg(key, value)
    # TODO: Figureout if this is actually needed as a flag like this
    "--#{key}=#{value}"
  end
end
