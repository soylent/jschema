# frozen_string_literal: true

require 'json'
require 'jschema'

desc 'Run JSON Schema test suite'
task :spec, :test_files do |t, args|
  args.with_defaults(test_files: 'JSON-Schema-Test-Suite/tests/draft4/*.json')
  test_files = Dir[args[:test_files]]

  if test_files.empty?
    abort "Could not find test files.\n" \
          "You need to copy json schema test suit first:\n" \
          "git clone git@github.com:json-schema/JSON-Schema-Test-Suite.git"
  end

  def spec_passed
    [1, 0, 0]
  end

  def spec_failed(test_file, specs, spec)
    puts "[F] #{test_file}: #{specs['description']} - #{spec['description']}"
    [0, 1, 0]
  end

  def spec_error(test_file, specs, error)
    puts "[E] #{test_file}: #{specs['description']} - #{error}"
    puts error.backtrace.take(10)
    [0, 0, 1]
  end

  def run_specs(specs, test_file)
    specs['tests'].map do |spec|
      begin
        jschema = JSchema.build(specs['schema'])
        result = jschema.valid?(spec['data']) == spec['valid']
        if result
          spec_passed
        else
          spec_failed test_file, specs, spec
        end
      rescue Exception => error
        spec_error(test_file, specs, error)
      end
    end
  end

  results = test_files.flat_map do |test_file|
    suite = JSON.parse File.read(test_file)
    suite.flat_map do |specs|
      run_specs(specs, test_file)
    end
  end

  passed, failed, errors = results.reduce do |sum, spec_res|
    sum.zip(spec_res).map { |r| r.reduce(&:+) }
  end

  puts "Passed: #{passed}, Failed: #{failed}, Errors: #{errors}"
  abort if errors + failed > 0
end
