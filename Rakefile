# frozen_string_literal: true

require 'rake/testtask'
require 'rubygems/package_task'

require 'json'
require 'jschema'

load 'json_schema_tests.rake'

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.warning = true
end

# Define gem packaging task
gemspec = Gem::Specification.load('jschema.gemspec')
Gem::PackageTask.new(gemspec) do |_pkg|
end

desc 'CI tasks'
task :ci do
  require 'coveralls'
  Coveralls.wear!
  Rake::Task[:test].invoke
end

task default: :ci
