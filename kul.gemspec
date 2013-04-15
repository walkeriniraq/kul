#!/usr/bin/env gem build
# encoding: utf-8

require "base64"

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kul/version'

Gem::Specification.new do |spec|
  spec.name          = 'kul'
  spec.version       = Kul::VERSION
  spec.authors       = ['Nathan Walker']
  spec.email         = [Base64.decode64('bmF0aGFuQHJ5bGF0aC5uZXQ=\n')]
  spec.description   = 'Kul Application Server'
  spec.summary       = 'A simple and dynamic web application server.'
  spec.homepage      = 'http://github.com/walkeriniraq/kul'
  spec.license       = 'MIT'

  # this would be a problem on a system without git
  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra', '~> 1.3.3'
  spec.add_runtime_dependency 'coffee-script', '2.2'
  spec.add_runtime_dependency 'sass', '~> 3.2.7'
  spec.add_development_dependency 'rspec', '~> 2.11'
  spec.add_development_dependency 'awesome_print', '~> 1.1'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'

  spec.executables << 'kul'
end
