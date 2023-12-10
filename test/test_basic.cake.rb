# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('Test Runner - Basic', [
  Group.new('Group Basic', [
    Test.new(
      'True should be true',
      assertions: proc { [Expect::IsTrue.new(true)] }
    )
  ])
])
