# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('All of these should fail in various ways', [
  Test.new('Should report multiple failures',
    assertions: proc {
      [
        ExpectEquals.new(actual: true, expected: false),
        # This line is meant to pass
        ExpectIsTrue.new(true),
        ExpectIsFalse.new(true),
        ExpectIsTrue.new(false)
      ]
    },
    options: TestOptions.new(fail_on_first_expect: false)),
  Test.new('Should report only one failure by default',
    assertions: proc {
      [
        ExpectEquals.new(actual: true, expected: false),
        # This line is meant to pass
        ExpectIsTrue.new(true),
        # This is a failure, but shouldn't be run
        ExpectIsFalse.new(true),
        # This is also a failure, and shouldn't be run
        ExpectIsTrue.new(false)
      ]
    }),
  Test.new('Should report only one failure if fail_on_first_expect is true',
    assertions: proc {
      [
        ExpectEquals.new(actual: true, expected: false),
        # This line is meant to pass
        ExpectIsTrue.new(true),
        # This is a failure, but shouldn't be run
        ExpectIsFalse.new(true),
        # This is also a failure, and shouldn't be run
        ExpectIsTrue.new(false)
      ]
    },
    options: TestOptions.new(fail_on_first_expect: true)),
  Group.new('Groups should report as failed when at least one test has failed', [
    Test.new('This test should fail', assertions: proc { [ExpectIsTrue.new(false)] }),
    Test.new('This test should pass', assertions: proc { [ExpectIsTrue.new(true)] })
  ])
])
