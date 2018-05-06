# frozen_string_literal: true

require 'jschema/validator_base'
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
  # JSON schema validators
  module Validator
    # Build a list of validators from a given JSON schema
    #
    # @param schema [Hash] JSON schema
    # @param parent [Schema] parent schema
    # @return [Array<ValidatorBase>]
    def self.build(schema, parent)
      if schema.is_a?(Hash)
        constants.map do |validator_class_sym|
          validator_class = const_get(validator_class_sym)
          validator_class.build(schema, parent)
        end.compact
      else
        []
      end
    end
  end
end
