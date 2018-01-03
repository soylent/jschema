require 'webmock/minitest'
require 'helper'

require 'support/assertion_helper'

class TestSchema < Minitest::Test
  include AssertionHelper

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

  def test_json_refenrece
    schema = Object.new
    JSchema::SchemaRef.stub :new, schema do
      schema_ref = JSchema::Schema.build('$ref' => '#/sch')
      assert_equal schema_ref, schema
    end
  end

  def test_that_tilda_is_unescaped
    expected_ref_uri = URI('#/definitions/sch~')
    assert_received JSchema::SchemaRef, :new, [expected_ref_uri, nil] do
      JSchema::Schema.build('$ref' => '#/definitions/sch~0')
    end
  end

  def test_that_forward_slash_is_unescaped
    expected_ref_uri = URI('#/definitions/sch/sch')
    assert_received JSchema::SchemaRef, :new, [expected_ref_uri, nil] do
      JSchema::Schema.build('$ref' => '#/definitions/sch~1sch')
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
    schema_def_uri = URI('#/definitions/schema1')
    schema = JSchema::Schema.build('definitions' => { 'schema1' => {} })
    definition = JSchema::SchemaRef.new(schema_def_uri, schema)
    assert_equal schema_def_uri, definition.uri
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

  def test_fragment
    sch = { "definitions" => { "schema1" => { "type" => "string" } } }
    schema = JSchema.build(sch)
    fragment = schema.fragment("#/definitions/schema1")
    assert_equal "#/definitions/schema1", fragment.to_s
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
