# frozen_string_literal: true

require_relative '../test_options'

# Contextual is a wrapper for Node and Node attributes
module Contextual
  # A Child is a Node that has a parent
  module Child
    # Handles assigning parent information to child
    #
    # @param parent_options [TestOptions] Options from parent to copy to child
    def assign_parent(parent_options)
      @parent_count = 0 if @parent_count.nil?
      @parent_count += 1

      @options = TestOptions.new if @options.nil?
      @options.map_from_parent(parent_options)
    end
  end
end
