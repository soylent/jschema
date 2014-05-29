require 'bigdecimal'
require 'uri'
require 'delegate'

require 'jschema/json_reference'
require 'jschema/schema_ref'
require 'jschema/schema_uri'
require 'jschema/schema'
require 'jschema/simple_validator'
require 'jschema/validator'
require 'jschema/string_length_validator'
require 'jschema/limit_validator'
require 'jschema/items_size_validator'
require 'jschema/validator/max_length'
require 'jschema/validator/min_length'
require 'jschema/validator/pattern'
require 'jschema/validator/enum'
require 'jschema/validator/items'
require 'jschema/validator/required'
require 'jschema/validator/properties'
require 'jschema/validator/max_properties'
require 'jschema/validator/min_properties'
require 'jschema/validator/dependencies'
require 'jschema/validator/type'
require 'jschema/validator/all_of'
require 'jschema/validator/any_of'
require 'jschema/validator/one_of'
require 'jschema/validator/not'
require 'jschema/validator/max_items'
require 'jschema/validator/min_items'
require 'jschema/validator/unique_items'
require 'jschema/validator/multiple_of'
require 'jschema/validator/maximum'
require 'jschema/validator/minimum'
require 'jschema/validator/format'

module JSchema
  class InvalidSchema < StandardError; end
  class UnknownError < StandardError; end

  def self.build(*args)
    Schema.build(*args)
  end
end
