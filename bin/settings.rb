# frozen_string_literal: true

require_relative '../lib/helpers/filter_settings'

# Converts args into easily accessible settings
class Settings
  attr_reader :verbose, :file_filter, :vs_code, :interactive, :test_filter, :show_help

  def initialize
    @verbose = ARGV.include?('-v') || ARGV.include?('--verbose')
    @file_filter = get_from_args('-f')
    @vs_code = ARGV.include? '--vs-code'
    @interactive = ARGV.include?('-i') || ARGV.include?('--interactive')
    @show_help = ARGV.include?('-h') || ARGV.include?('--help')
    @test_filter = FilterSettings.new(
      general_search_term: get_from_args('-t'),
      test_filter_term: get_from_args('--tt'),
      test_search_for: get_from_args('--tte'),
      group_filter_term: get_from_args('--tg'),
      group_search_for: get_from_args('--tge'),
      test_runner_filter_term: get_from_args('--tr'),
      test_runner_search_for: get_from_args('--tre')
    )
  end

  private

  # @param [String] flag
  # @return [String, Nil]
  def get_from_args(flag)
    index = ARGV.find_index(flag)
    return ARGV[index + 1] if index && index != ARGV.length - 1

    nil
  end
end
