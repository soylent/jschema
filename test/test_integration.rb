require 'helper'
require 'webmock/minitest'
require 'support/fixture_helper'

class TestIntegration < Minitest::Test
  include FixtureHelper

  def test_simple_schema
    stub_request(:get, 'http://json-schema.org/geo')
      .to_return(body: read_fixture('geo'))

    validate 'json_schema1', 'json_data1'
  end

  def test_advanced_schema
    validate 'json_schema2', 'json_data2'
  end

  private

  def validate(schema_name, data_name)
    schema = JSchema::Schema.build(fixture(schema_name))
    assert schema.valid?(fixture(data_name))
  end
end
