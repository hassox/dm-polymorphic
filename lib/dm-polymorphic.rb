require "rubygems"
require "pathname"

gem "dm-core", ">=0.10.0"
require "dm-core"


module DataMapper
  module Is
    module Polymorphic
      
      def is_polymorphic(name, id_type=String)
        self.class_eval <<-EOS, __FILE__, __LINE__
          property :"#{name}_class", Klass
          property :"#{name}_id",    #{id_type}
          
          def #{name}
            return nil if self.#{name}_class.nil? || self.#{name}_class == NilClass
            return nil if self.#{name}_id.nil?
            if (self.#{name}_class.class == Class)
              self.#{name}_class.get(self.#{name}_id)
            else
              klass = Kernel.const_get(self.#{name}_class.to_s)
              if klass.ancestors.include? DataMapper::Resource
                klass.get(self.#{name}_id)
              else
                nil
              end
            end
          end        

          def #{name}=(entity)
            self.#{name}_class = entity.class
            self.#{name}_id = entity.id
          end        
        EOS
      end
      
    end # Polymophic
  end # Is
end

DataMapper::Model.append_extensions DataMapper::Is::Polymorphic

require Pathname(__FILE__).dirname.expand_path / "associations.rb" 
require Pathname(__FILE__).dirname.expand_path / "types.rb" 
