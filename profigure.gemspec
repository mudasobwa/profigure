# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'profigure/version'

Gem::Specification.new do |spec|
  spec.name          = 'profigure'
  spec.version       = Profigure::VERSION
  spec.authors       = ["Alexei Matyushkin"]
  spec.email         = ["am@mudasobwa.ru"]
  spec.summary       = %q{Small library to ease the configure files operations}
  spec.description   = %q{Handles the YAML files in the manner as if they were configuration files}
  spec.homepage      = "http://mudasobwa.ru/projects/profigure"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'yard-cucumber'

  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'psych'
  spec.add_dependency 'hash-deep-merge'
end
