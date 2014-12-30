require 'rake/testtask'
require 'json'
require 'jschema'

load 'json_schema_tests.rake'
load 'performance/performance.rake'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/test_*.rb'
  test.warning = true
end

desc 'CI tasks'
task :ci do
  require 'coveralls'
  Coveralls.wear!

  tests = Dir['test/**/test_*.rb']
  tests.each do |test|
    require_relative test
  end
end

task default: :ci
