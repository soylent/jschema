require 'minitest/autorun'
require 'jschema'

class TestSchemaURI < Minitest::Test
  def test_default_uri
    assert_equal URI('#'), schema_uri
  end

  def test_schema_uri_when_parent_is_not_specified
    assert_equal URI('test'), schema_uri('test')
  end

  def test_schema_uri_when_parent_uri_is_absolute
    uri = schema_uri('test', 'http://example.com/')
    assert_equal URI('http://example.com/test'), uri
  end

  def test_schema_uri_when_parent_uri_is_relative
    assert_raises(JSchema::InvalidSchema) do
      schema_uri('relative/', 'relative/')
    end
  end

  def test_schema_uri_when_both_parent_and_schema_uri_are_absolute
    schema_id = 'http://example.com/'
    parent_id = 'http://localhost/'
    uri = schema_uri(schema_id, parent_id)
    assert_equal URI(schema_id), uri
  end

  def test_schema_uri_when_ids_are_not_specified
    assert_equal URI('#/child'), schema_uri(nil, nil, 'child')
  end

  def test_that_schema_uri_is_normalized
    uri = schema_uri('etc/../path', 'http://Example.com')
    assert_equal URI('http://example.com/path'), uri
  end

  def test_that_implicit_schema_id_treated_as_uri_fragment
    uri = schema_uri(nil, 'http://example.com/path#sch', 'sub')
    assert_equal URI('http://example.com/path#sch/sub'), uri
  end

  private

  def schema_uri(schema_id = nil, parent_id = nil, id = nil)
    parent_schema = JSchema::Schema.build('id' => parent_id) if parent_id || id
    schema = { 'id' => schema_id }
    JSchema::SchemaURI.build(schema, parent_schema, id)
  end
end
