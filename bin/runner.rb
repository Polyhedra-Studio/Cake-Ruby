# frozen_string_literal: true

require_relative 'collector'

# Controls IO and output
class Runner
  # Retrieves all files with a cake.rb extension in the current directory
  # @return [Array<String>]
  def cake_file_list
    # Get all files in the current directory, including subdirectories
    Dir.glob('**/*.cake.rb')
  end

  # Runs the tests
  # @param settings [Settings]
  # @param cake_list [Array<String>]
  def run(settings, cake_list)
    collector = Collector.new
    process_args = settings.test_filter.to_properties

    cake_list.each do |file|
      next if settings.file_filter && !file.include?(settings.file_filter)

      r, w = IO.pipe
      pid = Process.spawn('ruby', file, process_args.join(' '), out: w, err: %i[child out])
      w.close
      pid, status = Process.wait2
      output = r.read
      r.close

      collectors = test_runner_output_parser(output)
      collectors.each do |c|
        collector.add_collector(c)
      end

      puts "#{collector.total} tests found in #{file}..." if settings.verbose
    end

    collector.print_message(settings.verbose || settings.vs_code)
    return if settings.vs_code

    # This makes sure to clear out any color changes
    Printer.neutral('')
  end

  def show_help
    puts 'Usage: cake-tester [options]'
    puts '  -h, --help            Show this help message'
    puts '  -i, --interactive     Interactive mode'
    puts '  -v, --verbose         Verbose output'
    puts ''
    puts 'Test Filters: '
    puts <<~HELP
      -t    General search:         -t "foo"                  Run all tests, groups, and runners with "foo" in the title
      --tt  Test search:            --tt "cool test"          Run all tests with the phrase "cool test" in the title
      --tte Test search, exact:     --tte "should pass when true"      Runs only the test that matches the phrase exactly.
      --tg  Group search:           --tg "bar"                Run all groups matching "bar" in the title
      --tge Group search, exact:    --tge "API Endpoints"     Runs all groups exactly matching the phrase "API Endpoints"
      --tr  Test Runner search:     --tr "Models"             Runs all test runners with "Models" in the title
      --tre Test Runner search, exact: --tre "Models - User"       Runs test runners that exactly match the phrase "Models - User"
    HELP
  end

  private

  # Parses output from the process
  # @param output [String]
  # @return [Array<TestRunnerCollector>]
  def test_runner_output_parser(output)
    test_runner_collectors = []
    lines = output.lines
    cursor = 0

    while cursor < (lines.length - 1)
      line = lines[cursor]
      test_runner_collector = test_runner_output_parse(lines, cursor)
      cursor = test_runner_collector.end_index
      test_runner_collectors << test_runner_collector
    end

    test_runner_collectors
  end

  # @param lines [Array<String>] All output lines
  # @param cursor [Integer] Current index of the cursor in the output
  # @return [TestRunnerCollector]
  def test_runner_output_parse(lines, cursor)
    test_output = []
    total = 0
    successes = 0
    failures = 0
    neutrals = 0
    at_summary_line = -1
    summary_line = ' - Summary: ---------------'
    total_line = /(\d*) tests ran\./
    success_line = /(\d*) passed\./
    failed_line = /(\d*) failed\./
    neutral_line = %r{(\d*) skipped/inconclusive\.}
    i = cursor
    while i < lines.length - 1 || at_summary_line == 7
      line = lines[i]
      at_summary_line = 0 if line.include? summary_line

      case at_summary_line
      when 2
        total = total_line.match(line)[1].to_i
      when 3
        successes = success_line.match(line)[1].to_i
      when 4
        failures = failed_line.match(line)[1].to_i
      when 5
        neutrals = neutral_line.match(line)[1].to_i
      end

      if at_summary_line > -1
        at_summary_line += 1
      else
        test_output << line
      end

      i += 1
    end

    Test_Runner_Controller.new(
      test_output,
      total: total,
      successes: successes,
      failures: failures,
      neutrals: neutrals,
      end_index: i
    )
  end
end
