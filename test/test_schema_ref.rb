require 'minitest/autorun'
require 'jschema'

class TestSchemaRef < Minitest::Test
  def test_that_schema_ref_acts_like_schema
    schema = JSchema::Schema.build
    JSchema::JSONReference.stub :dereference, schema do
      assert_equal JSchema::SchemaRef.new(schema.uri, nil), schema
    end
  end

  def test_that_exception_is_raised_if_reference_is_incorrect
    JSchema::JSONReference.stub :dereference, nil do
      assert_raises(JSchema::InvalidSchema) do
        JSchema::SchemaRef.new('invalid', nil).parent
      end
    end
  end
end
