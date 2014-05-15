require 'rake/testtask'
require 'benchmark'
require 'json'
require 'jschema'

load 'json_schema_tests.rake'

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

namespace :perf do
  def json_data
    @json_data ||=
      JSON.parse File.read('test/fixtures/json_data2.json')
  end

  def schema_data
    @schema_data ||=
      JSON.parse File.read('test/fixtures/json_schema2.json')
  end

  desc 'Measure jschema initialization time'
  task :measure_build do
    Benchmark.bm do |b|
      b.report('Build') do
        1000.times { JSchema.build(schema_data) }
      end
    end
  end

  desc 'Measure data validation time'
  task :measure_validation do
    jschema = JSchema.build(schema_data)
    Benchmark.bm do |b|
      b.report('Validate') do
        1000.times { jschema.valid? json_data }
      end
    end
  end

  desc 'Profile jschema initialization code'
  task :profile_build do
    require 'profile'
    10.times { JSchema.build(schema_data) }
  end

  desc 'Profile validation code'
  task :profile_validation do
    jschema = JSchema.build(schema_data)

    require 'profile'
    10.times { jschema.valid? json_data }
  end
end
