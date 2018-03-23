require 'delegate'

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
          Kernel.raise(InvalidSchema, "Failed to dereference schema: #{@uri}")
      end
    end
  end
end
