require "rubygems"
require "pathname"

gem "dm-core", ">=0.9.6"
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
              Kernel.const_get(self.#{name}_class.to_s).get(self.#{name}_id)
            end
          end        

          def #{name}=(entity)
            self.#{name}_class = entity.class.name
            self.#{name}_id = entity.id
          end        
        EOS
      end
      
    end # Polymophic
  end # Is
  
  module Resource
    module ClassMethods
      include DataMapper::Is::Polymorphic
    end # module ClassMethods
  end # module Resource
  
end

require Pathname(__FILE__).dirname.expand_path / "associations.rb" 
require Pathname(__FILE__).dirname.expand_path / "types.rb" 
