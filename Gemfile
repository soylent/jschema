# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

group :test do
  gem 'minitest'
  gem 'webmock'
  gem 'rake'
  gem 'coveralls', require: false
  gem 'pry', require: false

  platforms :rbx do
    gem 'rubysl'
    gem 'json'
    gem 'rubinius-coverage', require: false
  end
end
