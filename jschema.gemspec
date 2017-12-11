Gem::Specification.new do |s|
  s.name        = 'jschema'
  s.version     = '0.2.1'
  s.summary     = 'JSON Schema implementation'
  s.description = 'Implementation of JSON Schema Draft 4'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/soylent/jschema'
  s.authors     = 'Konstantin Papkovskiy'
  s.email       = 'konstantin@papkovskiy.com'

  s.required_ruby_version = '>= 1.9.3'

  s.files        = Dir['lib/**/*.rb']
  s.require_path = 'lib'
  s.add_development_dependency 'benchmark-ips', '~> 2.7'
end
