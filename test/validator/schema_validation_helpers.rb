module SchemaValidationHelpers
  class SchemaStub
    def initialize(validation_results)
      @validation_results = validation_results.cycle
    end

    def valid?(instance)
      validate(instance).empty?
    end

    def validate(instance)
      result = @validation_results.next
      result ? [] : ['error']
    end
  end

  def stub_schema_validations(*validation_results)
    schema = SchemaStub.new(validation_results)
    JSchema::Schema.stub :build, schema do
      yield
    end
  end

  def generate_schema
    { 'id' => generate_schema_id }
  end

  def generate_schema_id
    @schema_id ||= '0'
    @schema_id = @schema_id.succ.freeze
  end
end
