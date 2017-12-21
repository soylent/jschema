Gem::Specification.new do |spec|
  spec.name = 'jschema'
  spec.version = '0.2.1'
  spec.summary = 'JSON Schema implementation'
  spec.description = 'Implementation of JSON Schema Draft 4'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/soylent/jschema'
  spec.authors = 'Konstantin Papkovskiy'
  spec.email = 'konstantin@papkovskiy.com'
  spec.required_ruby_version = '>= 1.9.3'
  spec.files = Dir['lib/**/*.rb']
  spec.require_path = 'lib'
  spec.add_development_dependency 'benchmark-ips', '~> 2.7'
end
