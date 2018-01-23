$LOAD_PATH.unshift(File.realpath(File.expand_path('..', __dir__)))

require 'benchmark/ips'
require 'json'
require 'lib/jschema'
require 'test/support/fixture_helpers'

json = FixtureHelpers.fixture('json_data2')
schema = FixtureHelpers.fixture('json_schema2')
jschema = JSchema.build(schema)

Benchmark.ips do |x|
  x.report(:build) { JSchema.build(schema) }
  x.report(:valid?) { jschema.valid?(json) }
end
