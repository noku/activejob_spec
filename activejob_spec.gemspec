# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activejob_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob_spec"
  spec.version       = ActiveJobSpec::VERSION
  spec.authors       = ["Peter Negrei"]
  spec.email         = ["negrei.petru@gmail.com"]

  spec.summary       = %q{RSpec matcher for ActiveJob}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/noku/activejob_spec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency 'actionpack'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'pry'
end
