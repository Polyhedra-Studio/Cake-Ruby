# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('Test Groups', [
  Group.new('Should run all children tests', [
    Test.new(
      'True should be true',
      assertions: proc { [Expect::IsTrue.new(true)] }
    ),
    Test.new('False should be false',
      assertions: proc { [Expect::IsFalse.new(false)] })
  ]),
  Group.new('Nested Group - Parent', [
    Group.new('Nested Group - Child', [
      Test.new('Nested test should pass',
        assertions: proc { [Expect::IsTrue.new(true)] })
    ])
  ])
])
