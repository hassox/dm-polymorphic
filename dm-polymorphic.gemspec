# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "dm-polymorphic"
  s.version     = "0.10.3"
  s.platform    = Gem::Platform::RUBY
  s.author      = "Daniel Neighman, Wayne E. Seguin, Ripta Pasay, Martin Linkhorst"
  s.email       = "has.sox@gmail.com, wayneeseguin@gmail.com, github@r8y.org, m.linkhorst@googlemail.com"
  s.homepage    = "http://github.com/hassox/dm-polymorphic"
  s.summary     = "DataMapper plugin enabling simple ActiveRecord style polymorphism"
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'dm-core', '>= 0.10.2'
end
