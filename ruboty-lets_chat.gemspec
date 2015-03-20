# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/lets_chat/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-lets_chat"
  spec.version       = Ruboty::LetsChat::VERSION
  spec.authors       = ["tily"]
  spec.email         = ["tily05@gmail.com"]
  spec.summary       = %q{Let's Chat adapter for Ruboty}
  spec.description   = %q{Let's Chat adapter for Ruboty}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "ruboty"
  spec.add_dependency "socket.io-client-simple"
end
