# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('Test Runner Cake Test', [
  Group.new('Runs a group', [
    Test.new(
      'Test in group runs',
      assertions: proc { [Expect::IsTrue.new(true)] }
    )
  ]),
  Group.new('Runs a nested group, parent', [
    Group.new('Runs a nested group, child', [
      Test.new('Test in a nested group runs',
        assertions: proc { [Expect::IsTrue.new(true)] })
    ])
  ]),
  Test.new('Individual test runs',
    assertions: proc { [Expect::IsTrue.new(true)] })
])
