require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/test_*.rb'
  test.warning = true
end

desc 'Generate test coverage report'
task :coverage do
  Rake::TestTask.new(:coverage_test) do |test|
    test.pattern = 'test'
    test.loader = :testrb
  end

  ENV['COVERAGE'] = '1'
  Rake::Task[:coverage_test].execute
end

task default: :test
