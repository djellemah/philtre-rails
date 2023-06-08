# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'philtre-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "philtre-rails"
  spec.version       = PhiltreRails::VERSION
  spec.authors       = ["John Anderson"]
  spec.email         = ["panic@semiosix.com"]
  spec.summary       = %q{Filtering for Sequel on rails}
  spec.description   = %q{The Sequel equivalent for Ransack, Metasearch, Searchlogic}
  spec.homepage      = "http://github.com/djellemah/philtre-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "philtre"
  spec.add_dependency "activemodel"

  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'faker'
end
