# frozen_string_literal: true

module SchemaValidationHelpers
  class SchemaStub
    def initialize(validation_results)
      @validation_results = validation_results.cycle
    end

    def valid?(instance)
      validate(instance).empty?
    end

    SUCCESS = [].freeze
    private_constant :SUCCESS

    ERROR = ['error'].freeze
    private_constant :ERROR

    def validate(_instance)
      @validation_results.next ? SUCCESS : ERROR
    end
  end

  private_constant :SchemaStub

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
