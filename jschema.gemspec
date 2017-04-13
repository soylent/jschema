Gem::Specification.new do |s|
  s.name        = 'jschema'
  s.version     = '0.3.0'
  s.summary     = 'JSON Schema implementation'
  s.description = 'Implementation of JSON Schema Draft 4'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/Soylent/jschema'
  s.authors     = 'Konstantin Papkovskiy'
  s.email       = 'konstantin@papkovskiy.com'

  s.required_ruby_version = '>= 1.9.3'

  s.files        = Dir['lib/**/*.rb'] + Dir['local_schemas/**/*.json']
  s.require_path = 'lib'
end
