# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "dm-polymorphic"
  s.version     = '1.0.2'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Neighman, Wayne E. Seguin, Ripta Pasay, Martin Linkhorst"]
  s.email       = ["has.sox@gmail.com, wayneeseguin@gmail.com, github@r8y.org, m.linkhorst@googlemail.com"]
  s.homepage    = "http://github.com/hassox/dm-polymorphic"
  s.summary     = "DataMapper plugin enabling simple ActiveRecord style polymorphism"
  s.description = s.summary

  s.rubyforge_project = "dm-polymorphic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # Runtime
  s.add_runtime_dependency 'dm-core'
  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'i18n'
  
  # Development
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'dm-sqlite-adapter'
  s.add_development_dependency 'dm-migrations'
end
