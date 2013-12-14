module ArgumentIsArrayOfSchemasTests
  def test_that_argument_is_array
    assert_raises(JSchema::InvalidSchema) { validator(0) }
  end

  def test_that_argument_is_not_empty_array
    assert_raises(JSchema::InvalidSchema) { validator [] }
  end

  def test_that_argument_contains_only_unique_values
    assert_raises(JSchema::InvalidSchema) { validator [{}, {}] }
  end

  def test_that_argument_contains_only_valid_json_schemas
    assert_raises(JSchema::InvalidSchema) do
      raises_error = -> (*_) { fail JSchema::InvalidSchema }
      JSchema::Schema.stub :build, raises_error do
        validator [{}]
      end
    end
  end
end
