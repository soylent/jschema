module ValidatorAssertionHelpers
  JSON_DATA_TYPES = {
    array: [],
    boolean: true,
    integer: 1,
    number: 1.2,
    object: {},
    string: 'test'
  }.freeze

  private_constant :JSON_DATA_TYPES

  def assert_raises_unless(keyword, *valid_types)
    invalid_values = JSON_DATA_TYPES.reject do |type, _|
      valid_types.include?(type)
    end.values

    assert_raises_for_values keyword, invalid_values
  end

  def assert_raises_unless_schema(keyword, value = {})
    raises_error = ->(*_) { raise JSchema::InvalidSchema }
    JSchema::Schema.stub :build, raises_error do
      assert_raises_for_values keyword, [value]
    end
  end

  def assert_raises_unless_schema_array(keyword)
    assert_raises_unless_schema keyword, [{}]
  end

  def assert_raises_unless_string_array(keyword)
    invalid_values = [0, [], ['test', 'test'], [0]]
    assert_raises_for_values keyword, invalid_values
  end

  def assert_raises_unless_non_empty_array(keyword)
    invalid_values = [0, [], ['test', 'test']]
    assert_raises_for_values keyword, invalid_values
  end

  def assert_raises_unless_non_negative_integer(keyword)
    assert_raises_unless keyword, :integer
    assert_raises_for_values keyword, [-1]
  end

  def assert_raises_for_values(keyword, invalid_values)
    invalid_values.each do |invalid_value|
      assert_raises(JSchema::InvalidSchema) do
        build_from_schema keyword => invalid_value
      end
    end
  end

  def validator(*args)
    validator_class.new(*args, nil)
  end

  def build_from_schema(schema = {})
    validator_class.build(schema, nil)
  end
end
