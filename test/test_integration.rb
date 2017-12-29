require 'helper'
require 'webmock/minitest'

class TestIntegration < Minitest::Test
  def test_simple_schema
    stub_request(:get, 'http://json-schema.org/geo')
      .to_return(body: Pathname.new('test/support/fixtures/geo.json'))

    validate 'json_schema1.json', 'json_data1.json'
  end

  def test_advanced_schema
    validate 'json_schema2.json', 'json_data2.json'
  end

  private

  def validate(schema_file, data_file)
    sch = json_fixture(schema_file).freeze
    schema = JSchema::Schema.build(sch)
    data = json_fixture(data_file)
    assert schema.valid?(data)
  end

  def json_fixture(filename)
    JSON.parse open(File.join('test', 'support', 'fixtures', filename)).read
  end
end
