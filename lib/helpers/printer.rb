# frozen_string_literal: true

class Printer
  # Prints a message in green to the console.
  #
  # Parameters:
  # - message: A string message to be printed.
  #
  # Returns:
  # None
  def self.pass(message)
    puts "\x1B[32m#{message}\x1B[0m"
  end

  # Prints a neutral message in red.
  #
  # Params:
  # - message: The error message to be displayed.
  #
  # Returns:
  # None
  def self.fail(message)
    puts "\x1B[31m#{message}\x1B[0m"
  end

  # Prints a neutral message in gray.
  #
  # Parameters:
  # - message: A string representing the message to be printed.
  #
  # Returns: None
  def self.neutral(message)
    puts "\x1B[90m#{message}\x1B[0m"
  end

  # Generates a summary message based on the total number of tests, the number of successful tests,
  # the number of failed tests, and the number of neutral tests. The summary message is formatted
  # as a box with the following structure:
  #
  # - Summary: -------------------
  # |                            |
  # |  $total tests ran.              |
  # |  - $successes passed.               |
  # |  - $failures failed.               |
  # |  - $neutrals skipped/inconclusive. |
  # -------------------------------
  #
  # Parameters:
  # - total (int): The total number of tests.
  # - successes (int): The number of successful tests.
  # - failures (int): The number of failed tests.
  # - neutrals (int): The number of neutral tests.
  #
  # Returns:
  # - message (str): The formatted summary message.
  def self.summary(total, successes, failures, neutrals)
    total_char_count = total.to_s.length
    success_char_count = successes.to_s.length
    failure_char_count = failures.to_s.length
    neutral_char_count = neutrals.to_s.length
    max_char_count = [total_char_count, success_char_count, failure_char_count, neutral_char_count].max

    base_top_dash_spacer = 18
    base_blank_spacer = 28
    base_total_spacer = 14
    base_success_spacer = 15
    base_failure_spacer = 15
    base_neutral_spacer = 1
    box_length = 29

    total_extra_space = max_char_count - total_char_count + base_total_spacer
    success_extra_space = max_char_count - success_char_count + base_success_spacer
    failure_extra_space = max_char_count - failure_char_count + base_failure_spacer
    neutral_extra_space = max_char_count - neutral_char_count + base_neutral_spacer

    # There are only two fields that might realistically overflow the box
    # - total and neutrals. Since total will always be >= passed and failed
    # count, we can just look at total and push out the space from there.
    all_extra_space = 0

    if neutral_extra_space == max_char_count && max_char_count > base_neutral_spacer
      all_extra_space = max_char_count - base_neutral_spacer
    elsif total_extra_space == max_char_count && max_char_count > base_total_spacer
      all_extra_space = max_char_count - base_total_spacer
    end

    # Create a box that looks like this:
    # - Summary: -------------------
    # |                            |
    # |  $total tests ran.              |
    # |  - $successes passed.               |
    # |  - $failures failed.               |
    # |  - $neutrals skipped/inconclusive. |
    # -------------------------------

    message = "\n"
    message += ' - Summary: '
    (base_top_dash_spacer + all_extra_space).times do
      message += '-'
    end
    message += "\n"

    # |                            | (blank spacer line)
    message += '|'
    (base_blank_spacer + all_extra_space).times do
      message += ' '
    end
    message += "|\n"

    # |  $total tests ran.              |
    message += "|  #{total} tests ran."
    (total_extra_space + all_extra_space).times do
      message += ' '
    end
    message += "|\n"

    # |  - $successes passed.               |
    message += "|  - #{successes} passed."
    (success_extra_space + all_extra_space).times do
      message += ' '
    end
    message += "|\n"

    # |  - $failures failed.               |
    message += "|  - #{failures} failed."
    (failure_extra_space + all_extra_space).times do
      message += ' '
    end
    message += "|\n"

    # |  - $neutrals skipped/inconclusive. |
    message += "|  - #{neutrals} skipped/inconclusive."
    (neutral_extra_space + all_extra_space).times do
      message += ' '
    end
    message += "|\n"

    # -------------------------------
    (box_length + all_extra_space).times do
      message += '-'
    end
    message += "\n"

    message
  end
end
