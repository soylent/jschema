# JSON Schema validator

[JSON Schema Documentation](http://json-schema.org/)

[![Build Status](https://travis-ci.org/Soylent/jschema.png?branch=master)](https://travis-ci.org/Soylent/jschema)
[![Coverage Status](https://coveralls.io/repos/Soylent/jschema/badge.png?branch=master)](https://coveralls.io/r/Soylent/jschema?branch=master)
[![Dependency Status](https://gemnasium.com/Soylent/jschema.png)](https://gemnasium.com/Soylent/jschema)

## About this gem

 - Implements JSON Schema draft 4 strictly according to the specification
 - Small, efficient and thread-safe
 - It uses only standard ruby libs
 - Clean and extensible code
 - Tested on Rubinius, MRI, and JRuby

## Synopsis

```ruby
  require 'jschema'

  # Create a new schema
  schema = JSchema.build('type' => 'string')

  # Validate input and return an array of validation errors
  schema.validate 0    # => ["`0` must be a string"]
  schema.validate 'ok' # => []

  # Validate input and return boolean value indicating validation result
  schema.valid? 0    # => false
  schema.valid? 'ok' # => true
```
