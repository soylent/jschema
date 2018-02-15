require 'bigdecimal'
require 'uri'
require 'delegate'

require 'jschema/json_reference'
require 'jschema/schema_ref'
require 'jschema/schema_uri'
require 'jschema/schema'
require 'jschema/validator'

module JSchema
  class InvalidSchema < StandardError; end
  class UnknownError < StandardError; end

  def self.build(*args)
    Schema.build(*args)
  end
end
