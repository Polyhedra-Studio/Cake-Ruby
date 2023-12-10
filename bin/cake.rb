# frozen_string_literal: true

require_relative 'settings'
require_relative 'runner'
require_relative '../lib/test_message'

settings = Settings.new
runner = Runner.new

cake_list = runner.cake_file_list

if cake_list.empty?
  TestMessage.new(
    'Cake Test Runner',
    'No tests found in this directory. Cake tests should end with ".cake.rb"'
  ).report
  exit
end

unless settings.interactive
  runner.run(settings)
  exit
end
