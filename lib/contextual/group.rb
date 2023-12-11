# frozen_string_literal: true

require_relative 'child'
require_relative 'node'
require_relative 'parent'

# A Group is a organizational class that holds other tests. You can nest as many
# groups as you like.
class Group < Contextual::Node
  include Contextual::Child
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
  end

  # Should this run with the current filter settings
  # @param filter_settings [FilterSettings]
  # @return [Boolean]
  def should_run_with_filter(filter_settings)
    # This should run failrly close to testRunner's version
    return @title == filter_settings.group_search_for if filter_settings.has_group_search_for
    return @title.include? filter_settings.group_filter_term if filter_settings.has_group_filter_term

    should_run_with_search_term_with_children(filter_settings)
  end

  # Report results, if any
  # @param filter_settings [FilterSettings]
  # @return [TestResult, Nil]
  def report(filter_settings)
    @result.report(@parent_count)
    return if @skip

    report_children(filter_settings)
  end
end
