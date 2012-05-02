# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'nagios-check/version'

Gem::Specification.new do |s|
  s.name          = 'nagios-check'
  s.version       = NagiosCheck::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Erik Grinaker']
  s.email         = ['erik@bengler.no']
  s.homepage      = 'http://github.com/bengler/nagios-check'
  s.summary       = 'Framework for writing Nagios checks'
  s.description   = 'Framework for writing Nagios checks'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
