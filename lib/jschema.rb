require 'uri'
require 'jschema/schema'

module JSchema
  class InvalidSchema < StandardError; end
  class UnknownError < StandardError; end

  def self.build(*args)
    Schema.build(*args)
  end
end
