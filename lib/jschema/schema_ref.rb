module JSchema
  # Schema reference is lazy evaluated.
  class SchemaRef < Delegator
    def initialize(uri, parent)
      @uri = uri
      @parent = parent
    end

    def __getobj__
      @schema ||= JSONReference.dereference(@uri, @parent)
    end
  end
end
