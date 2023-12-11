require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*.cake.rb']
  t.verbose = true
end

desc 'Run all tests'
task default: :test
