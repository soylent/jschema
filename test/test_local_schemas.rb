require 'minitest/autorun'

class TestLocalSchemas < Minitest::Test

  @@base = File.expand_path(File.join("..", "..", "local_schemas"), __FILE__)
  @@schema_file = File.join(@@base, "swagger", "v2.0", "schema.json")
  @@original = JSchema::LocalSchemas.to_h

  def setup
    JSchema::LocalSchemas.instance_variable_set(:@local_schemas, @@original)
  end
  def teardown
    setup
  end

  def test_invalid_urls
    assert_raises(ArgumentError) do
      JSchema::LocalSchemas.add "ftp://example.com/schema.json#", @@schema_file
    end
    assert_raises(ArgumentError) do
      JSchema::LocalSchemas.add "relative/schema.json#", @@schema_file
    end
  end

  def test_add_and_remove

    count = @@original.count
    k, v = @@original.first

    JSchema::LocalSchemas.remove k
    assert_equal count - 1, JSchema::LocalSchemas.to_h.count

    @@original.each do |k, v|
      JSchema::LocalSchemas.remove k
    end
    assert_equal 0, JSchema::LocalSchemas.to_h.count

    JSchema::LocalSchemas.add k, v
    assert_equal 1, JSchema::LocalSchemas.to_h.count

  end

  def test_dereferences_local_files

    url = "https://example.com/schema.json"
    source_schema = JSON.parse(File.read(@@schema_file))
    JSchema::LocalSchemas.add url, @@schema_file
    schema = JSchema::JSONReference.dereference(URI(url), nil)
    assert_equal source_schema, schema.to_h

  end

  def test_dereferences_local_embedded_schemas

    url = "https://example.com/schema-embedded.json"
    JSchema::LocalSchemas.add url, '{"id": "this_was_embedded.json#"}'
    schema = JSchema::JSONReference.dereference(URI(url), nil)
    assert_equal "this_was_embedded.json#", schema.to_h['id']

  end

end
