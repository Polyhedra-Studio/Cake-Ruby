# frozen_string_literal: true

require_relative '../lib/cake'

TestRunner.new('Simple Test with no groups', [
  Test.new(
    'True is true - assertion',
    assertions: proc {
                  [Expect::IsTrue.new(true)]
                }
  ),
  Test.new(
    'Equals, true is equal to true',
    assertions: proc {
                  [Expect::Equals.new(actual: true, expected: true)]
                }
  ),
  Test.new(
    'IsNotEqual, true is not equal to false',
    assertions: proc {
                  [Expect::IsNotEqual.new(actual: true, not_expected: false)]
                }
  ),
  Test.new(
    'IsNil, nil is nil',
    assertions: proc {
                  [Expect::IsNil.new(nil)]
                }
  ),
  Test.new(
    'IsNotNil, true is not nil',
    assertions: proc {
                  [Expect::IsNotNil.new(true)]
                }
  ),
  Test.new('RespondTo, true responds to is_a?',
    assertions: proc {
                  [Expect::RespondTo.new(true, :is_a?)]
                }),
  Test.new('Undefined, true does not respond to foo',
    assertions: proc {
                  [Expect::Undefined.new(true, :foo)]
                }),
  Test.new('DoesNotRepondTo, is a synonym for Undefined',
    assertions: proc {
                  [Expect::DoesNotRespondTo.new(true, :foo)]
                })
])
