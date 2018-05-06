# frozen_string_literal: true

require 'uri'
require 'jschema/schema'

# JSON schema implementation
module JSchema
  # Raised when a schema cannot be created
  class InvalidSchema < StandardError; end

  # Should never be raised
  class UnknownError < StandardError; end

  # Builds a new schema
  #
  # @see Schema.build
  def self.build(*args)
    Schema.build(*args)
  end
end
