module JSchema
  # Schema reference is lazy evaluated.
  class SchemaRef < Delegator
    def initialize(uri, parent)
      @uri = uri
      @parent = parent
    end

    def __getobj__
      @schema ||= begin
        JSONReference.dereference(@uri, @parent) ||
          Kernel.fail(InvalidSchema, "Failed to dereference schema: #{@uri}")
      end
    end
  end
end
