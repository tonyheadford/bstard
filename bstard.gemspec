# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bstard'

Gem::Specification.new do |spec|
  spec.name          = "bstard"
  spec.version       = Bstard::VERSION
  spec.authors       = ["Tony Headford"]
  spec.email         = ["tony@binarycircus.com"]

  spec.summary       = %q{A Lightweight State Machine}
  spec.description   = %q{Bstard is a New State(sman) Machine}
  spec.homepage      = "https://github.com/tonyheadford/bstard"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-reporters"
end
