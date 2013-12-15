require 'minitest/autorun'
require 'jschema'
require 'ostruct'

class TestJSONReference < Minitest::Test
  def test_schema_registration_and_dereferencing
    schema = OpenStruct.new(uri: 'registered')
    JSchema::JSONReference.register_schema schema
    assert_equal dereference(schema), schema
  end

  def test_schema_dereferencing_with_same_uri
    schema1 = OpenStruct.new(uri: 'uri', id: 1)
    schema2 = OpenStruct.new(uri: 'uri', id: 2)
    JSchema::JSONReference.register_schema schema1
    JSchema::JSONReference.register_schema schema2

    assert_equal dereference(schema1), schema1
    assert_equal dereference(schema2), schema2
  end

  def test_dereferencing_when_schema_is_not_found
    schema = OpenStruct.new(uri: 'unregistered')
    assert_raises(JSchema::InvalidSchema) do
      dereference schema
    end
  end

  private

  def dereference(schema)
    JSchema::JSONReference.dereference(schema.uri, schema)
  end
end
