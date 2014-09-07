# JSchema

Describe and validate your JSON data using JSchema – an implementation of JSON
schema v4. For more information on JSON schema please refer to the official
documentation – [JSON Schema Documentation](http://json-schema.org/).

[![Build Status](https://travis-ci.org/soylent/jschema.png?branch=master)](https://travis-ci.org/soylent/jschema)
[![Coverage Status](https://coveralls.io/repos/soylent/jschema/badge.png?branch=master)](https://coveralls.io/r/soylent/jschema?branch=master)
[![Code Climate](https://codeclimate.com/github/soylent/jschema.png)](https://codeclimate.com/github/soylent/jschema)

## Features

 - Implements JSON Schema draft 4 strictly according to the specification
 - Small, efficient and thread-safe
 - It uses only standard ruby libs
 - Clean and extensible code
 - Tested on Rubinius, MRI, and JRuby

## Installation

Add `jschema` to your `Gemfile` and execute `bundle install`.

## Basic usage example

```ruby
require 'jschema'

# Create a new schema describing user profile data
schema = JSchema.build(
  'type' => 'object',
  'properties' => {
    'email'    => { 'type' => 'string', 'format' => 'email' },
    'password' => { 'type' => 'string', 'minLength' => 6 },
    'sex'      => { 'type' => 'string', 'enum' => ['m', 'f'] }
  },
  'required' => ['email', 'password']
)

# Validate input and return an array of validation errors
schema.validate 'invalid_data'
# => ["`invalid_data` must be an object"]

schema.validate('email' => 'user@example.org', 'password' => 'kielbasa')
# => []

# Validate input and return boolean value indicating validation result
schema.valid? 'invalid_data'
# => false

schema.valid?('email' => 'user@example.org', 'password' => 'kielbasa')
# => true
```

## More advanced example

The following example shows how you can validate user's input. In this example
we implement a simple service that allows us to search for comics.

First let's define schema for the search query. It can also be used as
documentation for our service. We can add `title` and `description` fields for
each query param.

```javascript
// comic_search_query.json
{
    "title": "Comic search query",
    "description": "Fetches lists of comics with optional filters",
    "type": "object",
    "properties": {
        "characters": {
            "description": "Return only comics which feature the specified characters",
            "type": "array",
            "items": { "pattern": "^\\d+$" },
            "minItems": 1
        },
        "format": {
            "description": "Filter by the issue format type (comic or collection)",
            "type": "string",
            "enum": [ "comic", "collection" ]
        },
        "hasDigitalIssue": {
            "description": "Include only results which are available digitally",
            "type": "string",
            "enum": [ "1", "0" ],
            "default": "1"
        },
        "limit": {
            "description": "Limit the result set to the specified number of resources",
            "type": "integer",
            "minimum": 1,
            "maximum": 100
        }
    },
    "required": [ "characters" ]
}
```

Now we can use our query schema in order to validate user's input. Here is
implementation of the comic search service:

```ruby
# config.ru
require 'jschema'
require 'rack'
require 'json'

class ComicSearch
  class << self
    def call(env)
      request = Rack::Request.new(env)
      validation_errors = query_schema.validate(request.params)
      if validation_errors.empty?
        # Query is valid, request can be processed further
        Rack::Response.new('Valid query', 200)
      else
        # Query is not valid, show validation errors
        Rack::Response.new(validation_errors, 400)
      end
    end

    private

    def query_schema
      @schema ||= begin
        schema_data = JSON.parse File.read('./comic_search_query.json')
        JSchema.build(schema_data)
      end
    end
  end
end

run ComicSearch
# run the service by executing 'rackup'
```

## Contributing

Pull requests are very welcome. Please make sure that your changes
don't break the tests by running:

```sh
$ bundle exec rake
```

## License

MIT License (MIT)
