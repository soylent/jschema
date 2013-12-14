require 'minitest/autorun'
require 'jschema'

class TestSchemaRef < MiniTest::Unit::TestCase
  def test_that_schema_ref_acts_like_schema
    schema = JSchema::Schema.build
    JSchema::JSONReference.stub :dereference, schema do
      assert_equal JSchema::SchemaRef.new(schema.uri, nil), schema
    end
  end
end
