# JSchema

Describe and validate your JSON data using JSchema – an implementation of JSON
schema v4. For more information on JSON schema please refer to the official
documentation – [JSON Schema Documentation](http://json-schema.org/).

[![Build Status](https://travis-ci.org/soylent/jschema.svg?branch=master)](https://travis-ci.org/soylent/jschema)
[![Coverage Status](https://coveralls.io/repos/soylent/jschema/badge.svg?branch=master&service=github)](https://coveralls.io/github/soylent/jschema?branch=master)
[![Code Climate](https://codeclimate.com/github/Soylent/jschema/badges/gpa.svg)](https://codeclimate.com/github/Soylent/jschema)

## Features

 - Implements JSON Schema draft 4 strictly according to the specification
 - Can dereference schemas locally
 - Small, efficient and thread-safe
 - No dependencies
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

      # Validate request params using JSON schema
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
      # Create a new instance of JSchema unless it has
      # already been created.
      Thread.current[:schema] ||= begin
        schema_data = JSON.parse File.read('comic_search_query.json')
        JSchema.build(schema_data)
      end
    end
  end
end

run ComicSearch
```

Run the service:

    $ rackup -D

Make a valid request:

    $ curl -v --globoff ":9292/?characters[]=1"
    ...
    < HTTP/1.1 200 OK

Make a bad request:

    $ curl -v --globoff ":9292/?characters[]=first"
    ...
    < HTTP/1.1 400 Bad Request
    < first must match pattern "^\\d+$"

## Fragments

You can validate against part of a schema by extracting it into a new schema
object with `Schema#fragment`:

```ruby
schema = JSchema.build(
  'type' => 'object',
  'properties' => {
    'email': { '$ref' => '#/definitions/email' }
  },
  'definitions' => {
    'email' => { 'type' => 'string', 'format' => 'email' }
  })

email_schema = schema.fragment('#/definitions/email')
email_schema.valid?('valid@example.com')
# => true

email_schema.valid?('invalidexample.com')
# => false
```

## Local Schema Dereferencing

Schemas that are referenced via `$ref` or `$schema` can be dereferenced locally if the namespace is added to the local schemas cache. If not found in the local cache, a (costly) HTTP request must be made at runtime to fetch it.

We recommend for performance reasons that you add all referenced schemas to the local schema cache before using them.

```ruby
  # Deferences schema from a local file
  JSchema::LocalSchemas.add "http://example.com/schema.json#", "local/path/to/schema.json"
  JSchema::JSONReference.dereference URI("http://example.com/schema.json#/definitions/example"), nil

  # Dereferences schema from string
  JSchema::LocalSchemas.add "http://example.com/schema.json#", File.read("local/path/to/schema.json")
  JSchema::JSONReference.dereference URI("http://example.com/schema.json#/definitions/example"), nil
```

This gem automatically provides the following schemas locally (as part of the cache):

 * `http://json-schema.org/draft-04/schema#`
 * `http://json-schema.org/draft-04/hyper-schema#`
 * `http://swagger.io/v2/schema.json#`


## Contributing

Pull requests are very welcome!

* Please make sure that your changes don't break the tests by running:

      $ bundle exec rake

* Run a single test suite:

      $ ruby -Ilib test/test_suite.rb

* Run a single test:

      $ ruby -Ilib test/test_suite.rb -n /test_method_name/

## License

MIT License (MIT)
