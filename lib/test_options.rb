# TestOptions
#
# @param fail_on_first_expect, default value will be set to true
#
class TestOptions
  def fail_on_first_expect
    return true if @fail_on_first_expect.nil?

    @fail_on_first_expect
  end

  # @param fail_on_first_expect [Boolean]
  def initialize(fail_on_first_expect: nil)
    @fail_on_first_expect = fail_on_first_expect
  end

  # Maps options from parent onto this instance. If childy already has a setting,
  # it will not be overwritten.
  # @param parent [TestOptions]
  def map_from_parent(parent)
    return if parent.nil?

    @fail_on_first_expect = @fail_on_first_expect.nil? ? parent.fail_on_first_expect : @fail_on_first_expect
  end
end
