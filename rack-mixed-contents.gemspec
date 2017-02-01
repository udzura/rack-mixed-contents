# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/mixed_contents_version'

Gem::Specification.new do |spec|
  spec.name          = "rack-mixed-contents"
  spec.version       = Rack::MixedContents::VERSION
  spec.authors       = ["Uchio KONDO"]
  spec.email         = ["udzura@udzura.jp"]

  spec.summary       = %q{A Rack Middleware to help to fix mixed contents issues}
  spec.description   = %q{A Rack Middleware to help to fix mixed contents issues}
  spec.homepage      = "https://github.com/udzura/rack-mixed-contents"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_development_dependency "test-unit", ">= 3"
  spec.add_development_dependency "rack-test"

  spec.add_development_dependency "bundler", ">= 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
