Gem::Specification.new do |s|
  s.name        = "jschema"
  s.version     = "0.0.0"
  s.date        = "2013-11-11"
  s.summary     = "JSON Schema implementation"
  s.description = "Implementation of JSON Schema Draft 4"
  s.license     = "MIT"
  s.homepage    = "http://github.com/Soylent/jschema"
  s.authors     = "Konstantin Papkovskiy"
  s.email       = "konstantin@papkovskiy.com"

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = ">= 1.9.3"

  s.files       = Dir["lib/**/*.rb"]
  s.test_files  = Dir["test/**/*.rb"]

  s.require_path = "lib"

  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"
end
