require 'minitest/autorun'
require 'webmock/minitest'
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
    stub_validators(true) do |schema|
      assert schema.valid?('instance')
      assert_empty schema.validate('instance')
    end
  end

  def test_failing_validation
    stub_validators(false) do |schema|
      refute schema.valid?('instance')
      refute_empty schema.validate('instance')
    end
  end

  def test_default_schema_uri
    assert_equal URI('#'), schema_uri
  end

  def test_schema_uri_when_parent_is_not_specified
    assert_equal URI('test'), schema_uri('test')
  end

  def test_schema_uri_when_parent_uri_is_absolute
    stub_request(:get, 'http://example.com/test').to_return(body: '{}')
    uri = schema_uri('test', 'http://example.com/')
    assert_equal URI('http://example.com/test'), uri
  end

  def test_schema_uri_when_parent_uri_is_relative
    assert_raises(JSchema::InvalidSchema) do
      schema_uri('relative/', 'relative/')
    end
  end

  def test_schema_uri_when_both_parent_and_schema_uri_are_absolute
    stub_request(:get, 'http://example.com/').to_return(body: '{}')
    schema_id = 'http://example.com/'
    parent_id = 'http://localhost/'
    uri = schema_uri(schema_id, parent_id)
    assert_equal URI(schema_id), uri
  end

  def test_schema_uri_when_ids_are_not_specified
    assert_equal URI('#/child'), schema_uri(nil, nil, 'child')
  end

  def test_that_schema_uri_is_normalized
    stub_request(:get, 'http://example.com/path').to_return(body: '{}')
    uri = schema_uri('etc/../path', 'http://Example.com')
    assert_equal URI('http://example.com/path'), uri
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
  def test_schema_caching
    parent = JSchema::Schema.build
    sch = { 'type' => 'string' }
    schema1 = JSchema::Schema.build(sch, parent)
    schema2 = JSchema::Schema.build(sch, parent)
    assert_equal schema1.object_id, schema2.object_id
  end

  # TODO: Make it isolated.
  def test_that_root_schemas_are_not_cached
    sch = { 'type' => 'string' }
    schema1 = JSchema::Schema.build(sch)
    schema2 = JSchema::Schema.build(sch)
    refute_equal schema1.object_id, schema2.object_id
  end

  # TODO: Make it isolated.
  def test_definitions
    schema_def_uri = '#/definitions/schema1'
    schema = JSchema::Schema.build('definitions' => { 'schema1' => {} })
    definition = JSchema::SchemaRef.new(schema_def_uri, schema)
    assert_equal URI(schema_def_uri), definition.uri
  end

  def test_that_exception_is_raised_when_schema_version_is_not_supported
    assert_raises(JSchema::InvalidSchema) do
      JSchema::Schema.build('$schema' => 'unsupported')
    end
  end

  def test_to_s
    schema = JSchema::Schema.build
    assert_equal '#', schema.to_s
  end

  def test_simplified_syntax
    assert_instance_of JSchema::Schema, JSchema.build
  end

  private

  def stub_validators(ret_val)
    validator = validator_stub.new(ret_val)
    JSchema::Validator.stub :build, [validator] do
      yield JSchema::Schema.build
    end
  end

  def validator_stub
    Struct.new(:valid) do
      def validate(_)
        valid ? nil : ['error']
      end
    end
  end

  def schema_uri(schema_id = nil, parent_id = nil, id = nil)
    parent = JSchema::Schema.build('id' => parent_id) if parent_id || id
    child = JSchema::Schema.build({ 'id' => schema_id }, parent, id)
    child.uri
  end
end
