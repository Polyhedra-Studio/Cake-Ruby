# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('Test Runner can skip', skip: true)
TestRunner.new(
  'Test Runner with children can skip', [
    Group.new('This group should be skipped', [
      Test.new('This test should be skipped', assertions: proc {
        [Expect::IsTrue.new(true)]
      })
    ]),
    Test.new('This test should be skipped', assertions: proc {
      [Expect::IsTrue.new(true)]
    })
  ],
  skip: true
)

TestRunner.new('Test Runner - Children marked skipped should skip', [
  Group.new('Group - Group marked as skip should be skipped', [
    Test.new('Children of skipped group should also be skipped', assertions: proc {
      [Expect::IsTrue.new(true)]
    })
  ], skip: true),
  Group.new('Group - Siblings not marked as skipped should not be skipped', [
    Test.new('This test should not be skipped', assertions: proc {
      [Expect::IsTrue.new(true)]
    })
  ]),
  Test.new('Test - Tests marked as skip should be skipped', assertions: proc {
    [Expect::IsTrue.new(true)]
  }, skip: true),
  Test.new('Test - Siblings of skipped test should not be skipped', assertions: proc {
    [Expect::IsTrue.new(true)]
  })
])
