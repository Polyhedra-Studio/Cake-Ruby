# frozen_string_literal: true

# Contains the base class for all test and assertion results
module Result
  def successes
    0
  end

  def failures
    0
  end

  def neutrals
    0
  end

  private

  def generate_spacer(spacer_count)
    @spacer = ''
    return if spacer_count.zero?

    (0..(spacer_count - 1)).each do |i|
      @spacer += if i < (spacer_count - 1)
                   '   '
                 else
                   ' `-'
                 end
    end
  end
end

# @abstract Contains the base class for all test results
class TestResult
  include Result

  def initialize(title)
    @title = title
  end

  def report(spacer_count = 0)
    generate_spacer(spacer_count)
  end
end

# @abstract Contains the base class for all assertion results
class AssertResult
  include Result
  attr_writer :index

  def initialize(message, index)
    @message = message
    @index = index
  end

  def report(spacer_count = 0)
    generate_spacer(spacer_count)
  end

  private

  def format_message
    # Asserts will always be indented, thus the 4 spaces
    if @index.nil?
      "    #{@message}"
    else
      "    [##{@index}] #{@message}"
    end
  end
end
