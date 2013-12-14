module JSchema
  module Validator
    def self.build(schema, parent)
      validators = []
      if schema.is_a?(Hash)
        constants.each do |validator_class_sym|
          validator_class = const_get(validator_class_sym)
          if (validator = validator_class.build(schema, parent))
            validators << validator
          end
        end
      end

      validators
    end
  end
end
