# frozen_string_literal: true

require_relative '../lib/cake'

teardown_counter = 0

TestRunner.new('Test Runner - Context', [
  Test.new(
    'Action should set "actual"',
    action: ->(_test) { true },
    assertions: ->(test) { [Expect::IsTrue.new(test.actual)] }
  ),
  Test.new(
    'Action can set "actual" and "expected"',
    action: ->(test) {
              value = 'foo'
              test.actual = value
              test.expected = value
            },
    assertions: ->(test) { [Expect::Equals.new(actual: test.actual, expected: test.expected)] }
  ),
  Test.new(
    'Other variables can be declared in context',
    action: ->(test) {
      test.foo = 'bar'
    },
    assertions: ->(test) {
      [Expect::Equals.new(
        actual: test.foo,
        expected: 'bar'
      )]
    }
  ),
  Test.new(
    'Siblings should not affect each other',
    assertions: ->(test) {
      [Expect::IsNil.new(test.foo)]
    }
  ),
  Test.new(
    'Values can be set in setup',
    setup: ->(test) {
      test.actual = true
      test.expected = true
      test.foo = 'bar'
    },
    assertions:
      ->(test) {
        [
          Expect::Equals.new(actual: test.foo, expected: 'bar'),
          Expect::Equals.new(actual: test.actual, expected: test.expected)
        ]
      }
  ),
  Test.new(
    'Values can be modified in teardown',
    setup: ->(_test) {
      teardown_counter += 1
    },
    assertions: ->(_test) {
                  [
                      Expect::IsTrue.new(teardown_counter.positive?)
                    ]
                },
    teardown: ->(_test) {
      teardown_counter = 0
    }
  ),
  Test.new(
    'Teardown reset value',
    assertions: ->(_test) {
                  [
                      Expect::IsTrue.new(teardown_counter.zero?)
                    ]
                }
  ),
  Group.new('Groups can assign context', [
    Test.new(
      'Group can pass context to children',
      assertions: ->(test) { [Expect::Equals.new(actual: test.foo, expected: 'bar')] }
    ),
    Test.new(
      'Children can override parent context',
      action: ->(test) { test.foo = 'baz' },
      assertions: ->(test) { [Expect::Equals.new(actual: test.foo, expected: 'baz')] }
    )
  ], setup: ->(test) {
    test.foo = 'bar'
  }),
  Group.new('Groups can modify values in teardown after children have run', [
    Test.new(
      'Teardown counter should be 1',
      assertions: proc { [Expect::Equals.new(actual: teardown_counter, expected: 1)] }
    )
  ],
  setup: proc { teardown_counter += 1 },
  teardown: proc { teardown_counter = 0 }),
  Test.new(
    'Teardown reset value',
    assertions: proc { [Expect::Equals.new(actual: teardown_counter, expected: 0)] }
  )
])
