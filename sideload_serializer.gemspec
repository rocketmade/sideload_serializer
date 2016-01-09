# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sideload_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "sideload_serializer"
  spec.version       = SideloadSerializer::VERSION
  spec.authors       = ["Daniel Evans"]
  spec.email         = ["evans.daniel.n@gmail.com"]

  spec.summary       = %q{A simple Sideloaded JSON Adapter for Active Model Serializers}
  spec.homepage      = "https://github.com/rocketmade/sideload_serializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "active_model_serializers", ">= 0.10.0.rc3"
  spec.add_dependency "camelize_keys"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
