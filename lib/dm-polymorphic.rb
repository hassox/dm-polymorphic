require "rubygems"
require "pathname"

gem "dm-core", ">=0.9.6"
require "dm-core"


module DataMapper
  module Is
    module Polymorphic
      
      def is_polymorphic(name, id_type=String)
        self.class_eval <<-EOS, __FILE__, __LINE__
          property :"#{name}_class", Class
          property :"#{name}_id",    #{id_type}
          
          def #{name}
            return nil if self.#{name}_class.nil?
            if (self.#{name}_class.class == String)
              Kernel.const_get(self.#{name}_class).get(self.#{name}_id)
            else
              self.#{name}_class.get(self.#{name}_id)
            end
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
