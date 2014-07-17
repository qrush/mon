# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mon/version'

Gem::Specification.new do |spec|
  spec.name          = "mon"
  spec.version       = Mon::VERSION
  spec.authors       = ["Nick Quaranto"]
  spec.email         = ["nick@quaran.to"]
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.summary = spec.description = %q{Pokémon battle simulator}

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "sequel"
  spec.add_dependency "sqlite3"
end
