Gem::Specification.new do |s|
  s.name        = 'jschema'
  s.version     = '0.0.2'
  s.summary     = 'JSON Schema implementation'
  s.description = 'Implementation of JSON Schema Draft 4'
  s.license     = 'MIT'
  s.homepage    = 'http://github.com/Soylent/jschema'
  s.authors     = 'Konstantin Papkovskiy'
  s.email       = 'konstantin@papkovskiy.com'

  s.required_ruby_version = '>= 1.9.3'

  s.files       = Dir['lib/**/*.rb']
  s.test_files  = Dir['test/**/*.rb']

  s.require_path = 'lib'
end
