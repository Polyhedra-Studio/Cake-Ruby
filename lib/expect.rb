# frozen_string_literal: true

# Contains expects in order to run assertions in a [#Test]
module Expect
  # @abstract Base class for Expects. Override {#run} to implement the
  #   validation logic.
  class ExpectBase
    attr_accessor :actual, :expected

    # @param [Object] actual
    # @param [Object] expected
    def initialize(actual:, expected: nil)
      @actual = actual
      @expected = expected
    end

    # Runs the validator and returns an AssertResult
    # @return [AssertPass, AssertFailure]
    def run
      AssertFailure.new("No expectation defined for #{@actual}.")
    end
  end

  # Checks if actual == expected
  class Equals < ExpectBase
    def run
      return AssertPass.new if @actual == @expected

      @actual = @actual.nil? ? '<nil>' : @actual
      @expected = @expected.nil? ? '<nil>' : @expected
      AssertFailure.new("Equality failed: Expected #{@expected}, got #{@actual}.")
    end
  end

  # Checks if actual != expected
  class IsNotEqual < ExpectBase
    def initialize(actual:, not_expected:)
      super(actual: actual, expected: not_expected)
    end

    def run
      return AssertPass.new if @actual != @expected

      @actual = @actual.nil? ? '<nil>' : @actual
      @expected = @expected.nil? ? '<nil>' : @expected
      AssertFailure.new("Inequality failed: Expected #{@expected} to not equal #{@actual}.")
    end
  end

  # Checks if actual is nil
  class IsNil < ExpectBase
    def initialize(actual)
      super(actual: actual)
    end

    def run
      return AssertPass.new if @actual.nil?

      AssertFailure.new("IsNil failed: Expected #{@actual} to be nil.")
    end
  end

  # Checks if actual is not nil
  class IsNotNil < ExpectBase
    def initialize(actual)
      super(actual: actual)
    end

    def run
      return AssertPass.new unless @actual.nil?

      AssertFailure.new("IsNotNil failed: Expected #{@actual} to not be nil.")
    end
  end

  # Checks if actual is truthy
  class IsTrue < ExpectBase
    def initialize(actual)
      super(actual: actual)
    end

    def run
      return AssertPass.new if @actual

      @actual = @actual.nil? ? '<nil>' : @actual
      AssertFailure.new("IsTrue failed: Expected #{@actual} to be true.")
    end
  end

  # Checks if actual is falsey
  class IsFalse < ExpectBase
    def initialize(actual)
      super(actual: actual, expected: true)
    end

    def run
      return AssertPass.new unless @actual

      AssertFailure.new("IsFalse failed: Expected #{@actual} to be false.")
    end
  end

  # Checks if actual responds to a method
  class RespondTo < ExpectBase
    def initialize(actual, method)
      super(actual: actual)
      @method = method
    end

    def run
      return AssertPass.new if @actual.respond_to?(@method)

      @actual = @actual.nil? ? '<nil>' : @actual
      AssertFailure.new("RespondsTo failed: Expected #{@actual} to respond to #{@method}.")
    end
  end

  # Checks if actual does not respond to a method
  class Undefined < ExpectBase
    def initialize(actual, method)
      super(actual: actual)
      @method = method
    end

    def run
      return AssertPass.new unless @actual.methods.include?(@method)

      @actual = @actual.nil? ? '<nil>' : @actual
      AssertFailure.new("Undefined failed: Expected #{@actual} to not respond to #{@method}.")
    end
  end

  # @note (see Expect::Undefined)
  class DoesNotRespondTo < Undefined
  end
end
