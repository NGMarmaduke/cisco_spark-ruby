# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cisco_spark/version'

Gem::Specification.new do |spec|
  spec.name          = "cisco_spark"
  spec.version       = CiscoSpark::VERSION
  spec.authors       = ["Nick Maher"]
  spec.email         = ["nickpmaher@gmail.com"]

  spec.required_ruby_version = '>= 1.9.2'

  spec.summary       = "Ruby client for Cisco Spark: https://developer.ciscospark.com"
  spec.homepage      = "https://github.com/NGMarmaduke/cisco_spark-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
end
