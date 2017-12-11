require 'benchmark/ips'
require 'jschema'
require 'json'

json = JSON.parse(File.read('test/fixtures/json_data2.json'))
schema = JSON.parse(File.read('test/fixtures/json_schema2.json'))
jschema = JSchema.build(schema)

Benchmark.ips do |x|
  x.report(:build) { JSchema.build(schema) }
  x.report(:valid?) { jschema.valid?(json) }
end
