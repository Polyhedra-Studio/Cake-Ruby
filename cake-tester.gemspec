# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name          = 'cake-tester'
  gem.version       = '0.2.1'
  gem.authors       = ['Polyhedra', 'C. Lee Spruit']
  gem.summary       = 'The lightweight, explicit testing framework for Ruby.'
  gem.description   = ''
  gem.homepage      = 'https://github.com/Polyhedra-Studio/Cake-Ruby'
  gem.license       = 'MPL-2.0'
  gem.required_ruby_version = '>= 2.7.0'
  gem.metadata['rubygems_mfa_required'] = 'true'

  gem.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  gem.executables << 'cake'
  gem.require_paths = ['lib']
end
