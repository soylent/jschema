require 'minitest/autorun'
require 'jschema'

require_relative 'assert_received'

class TestSchema < Minitest::Test
  def test_empty_schema
    JSchema::Validator.stub :build, [] do
      empty_schema = JSchema::Schema.build
      assert empty_schema.valid?('test')
    end
  end

  def test_passing_validation
    stub_validators('instance', true) do |schema|
      assert schema.valid?('instance')
    end
  end

  def test_failing_validation
    stub_validators('instance', false) do |schema|
      refute schema.valid?('instance')
    end
  end

  def test_default_schema_uri
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
    assert_equal 'http://example.com/path', uri.to_s
  end

  def test_json_refenrece
    schema = Object.new
    JSchema::SchemaRef.stub :new, schema do
      schema_ref = JSchema::Schema.build('$ref' => '#/sch')
      assert_equal schema_ref, schema
    end
  end

  def test_storing_schema_in_registry
    sch = Object.new
    JSchema::Schema.stub :new, sch do
      assert_received JSchema::JSONReference, :register_schema, [sch] do
        JSchema::Schema.build
      end
    end
  end

  # TODO: Make it isolated.
  def test_definitions
    schema_def_uri = '#/definitions/schema1'
    schema = JSchema::Schema.build('definitions' => { 'schema1' => {} })
    definition = JSchema::SchemaRef.new(schema_def_uri, schema)
    assert_equal URI(schema_def_uri), definition.uri
  end

  private

  def stub_validators(instance, ret_val)
    validator = Minitest::Mock.new
    validator.expect :valid?, ret_val, [instance]
    JSchema::Validator.stub :build, [validator] do
      yield JSchema::Schema.build
    end
    validator.verify
  end

  def schema_uri(schema_id = nil, parent_id = nil, id = nil)
    parent = JSchema::Schema.build('id' => parent_id) if parent_id || id
    child = JSchema::Schema.build({ 'id' => schema_id }, parent, id)
    child.uri
  end
end
