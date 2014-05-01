# JSchema

Describe and validate your JSON data using JSchema – an implementation of JSON
schema v4. For more information on JSON schema please refer to the official
documentation – [JSON Schema Documentation](http://json-schema.org/).

[![Build Status](https://travis-ci.org/Soylent/jschema.png?branch=master)](https://travis-ci.org/Soylent/jschema)
[![Coverage Status](https://coveralls.io/repos/Soylent/jschema/badge.png?branch=master)](https://coveralls.io/r/Soylent/jschema?branch=master)
[![Code Climate](https://codeclimate.com/github/Soylent/jschema.png)](https://codeclimate.com/github/Soylent/jschema)

## Features

 - Implements JSON Schema draft 4 strictly according to the specification
 - Small, efficient and thread-safe
 - It uses only standard ruby libs
 - Clean and extensible code
 - Tested on Rubinius, MRI, and JRuby

## Installation
Add the gem to your `Gemfile`
``` ruby
gem 'jschema'
```
And then run
``` sh
$ bundle install
```

## Usage

``` ruby
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

## Contributing

Pull requests are very welcome. Please make sure that your changes
don't break the tests by running:
``` sh
$ bundle exec rake
```

## License

MIT License (MIT)
