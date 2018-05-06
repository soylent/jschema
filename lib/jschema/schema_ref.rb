# frozen_string_literal: true

require 'delegate'

module JSchema
  # Lazily evaluated schema reference
  #
  # @api private
  class SchemaRef < Delegator
    # @param uri [URI::Generic] schema URI
    # @param parent [Schema] parent schema
    def initialize(uri, parent)
      @uri = uri
      @parent = parent
    end

    def __getobj__ # :nodoc:
      @schema ||= begin
        JSONReference.dereference(@uri, @parent) ||
          Kernel.raise(InvalidSchema, "Failed to dereference schema: #{@uri}")
      end
    end
  end
end
