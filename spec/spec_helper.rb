require 'rubygems'
require 'rake'
require 'rspec'

require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'

require 'active_support'

DataMapper.setup(:default, 'sqlite::memory:')

require File.join(File.dirname(__FILE__), '..', 'lib/dm-polymorphic.rb')

Rspec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
end
