require 'rake/testtask'
require 'rubygems/package_task'

require 'json'
require 'jschema'

load 'json_schema_tests.rake'
load 'performance/performance.rake'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/test_*.rb'
  test.warning = true
end

# Define gem packaging task
gemspec = Gem::Specification.load('jschema.gemspec')
Gem::PackageTask.new(gemspec) do |_pkg|
end

desc 'Updates the schema cache'
task :update_local_schemas do
  require "open-uri"
  JSchema::LocalSchemas.to_h.each do |namespace, path|
    begin
      contents = open(namespace).read
      schema = JSON.parse(contents) rescue raise("Could not parse file #{namespace}")
      if schema['id'] != namespace
        raise "ID #{schema['id']} does not match"
      end
    rescue => e
      raise "Error parsing #{namespace} -- #{e.class}: #{e.message}"
    end
    puts "#{namespace} written to #{path}"
    File.write(path, open(namespace).read)
  end
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
