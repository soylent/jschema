# JSON Schema validator

If you are not familiar with JSON schema, please study
[JSON Schema](http://json-schema.org)

## About

 - Implements JSON Schema draft 4 strictly according to the specification
 - Small, efficient and thread-safe
 - It uses only standard ruby libs
 - Tested on Rubinius, MRI, and JRuby

## Synopsis

```ruby
  # Creating a new schema
  schema = JSchema::Schema.build('type' => 'string')

  # Validating data and inspecting validation errors
  schema.validate 0    # => ["`0` must be a string"]
  schema.validate 'ok' # => []

  # Or you can just validate data
  schema.valid? 0    # => false
  schema.valid? 'ok' # => true
```
