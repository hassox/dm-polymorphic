require "rubygems"
require "pathname"
require "dm-core"
require "extlib/inflection"

require Pathname(__FILE__).dirname.expand_path / "associations.rb"
require Pathname(__FILE__).dirname.expand_path / "types.rb" 

module DataMapper
  module Is
    module Polymorphic
      def is_polymorphic(name, id_type=String)
        belongs_to name, :polymorphic => true
      end
    end # Polymophic
  end # Is
end

DataMapper::Model.append_extensions DataMapper::Is::Polymorphic