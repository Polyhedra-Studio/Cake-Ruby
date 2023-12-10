# frozen_string_literal: true

require 'ostruct'

# The Context is used to pass information between different stages of a Test.
# Context is inherited from parent to child, but not sibling to sibling.
# The Context object is an OpenStruct, which means you can dynamically assign
# as needed.
class Context < OpenStruct
  # @param [Object] actual expected object, ideally will be set during the
  #   Contexual::Node#run_action step
  # @param [Object] expected
  attr_accessor :expected, :actual

  def initialize
    super
    @expected = nil
    @actual = nil
  end

  # @param [Context] parent_context
  def apply(parent_context)
    @expected = parent_context.expected
    @actual = parent_context.actual

    parent_context.each_pair do |key, value|
      self[key] = value
    end
  end
end
