module JSchema
  module Validator
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
