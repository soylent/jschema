require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/test_*.rb'
  test.warning = true
end

desc 'CI tasks'
task :ci do
  ENV['COVERAGE'] = '1'
  Rake::Task[:test].execute
end

task default: :ci
