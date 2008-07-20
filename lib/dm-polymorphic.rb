require 'rubygems'
require 'pathname'

gem 'dm-core', '>=0.9.1'
require 'dm-core'


module DataMapper
  module Is
    module Polymorphic
      
      def is_polymorphic(name) 
        self.class_eval <<-EOS, __FILE__, __LINE__
          property :"#{name}_class",  Class
          property :"#{name}_id",     Integer
          
          def #{name}
            return nil if self.#{name}_class.nil?
            #{name}_class.get(#{name}_id)
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


require Pathname(__FILE__).dirname.expand_path / 'associations.rb' 
require Pathname(__FILE__).dirname.expand_path / 'types.rb' 


