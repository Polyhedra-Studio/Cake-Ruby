# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name          = 'cake_tester'
  gem.version       = '0.2.0'
  gem.authors       = ['Polyhedra', 'C. Lee Spruit']
  gem.summary       = 'The lightweight, explicit testing framework for Ruby.'
  gem.description   = ''
  gem.homepage      = 'https://github.com/Polyhedra-Studio/Cake-Ruby'
  gem.license       = 'MPL-2.0'
  gem.required_ruby_version = '>= 2.7.0'
  gem.metadata['rubygems_mfa_required'] = 'true'

  gem.files = `git ls-files -z`.split("\x0")
  # gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.executables << 'cake'
  gem.require_paths = ['lib']
end
