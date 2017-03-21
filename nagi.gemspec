# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'nagi/version'

Gem::Specification.new do |s|
  s.name          = 'nagi'
  s.version       = Nagi::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Erik Grinaker']
  s.email         = ['erik@bengler.no']
  s.homepage      = 'http://github.com/bengler/nagi'
  s.summary       = 'A DSL for writing Nagios plugins'
  s.description   = 'A DSL for writing Nagios plugins'
  s.license       = 'GPL-3.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
