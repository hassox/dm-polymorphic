module DataMapper
  module Model
    module Relationship
      
      alias :has_without_polymorphism :has
      
      def has(cardinality, name, *args)
        opts = args.last.kind_of?(::Hash) ? args.pop : {}
        if as = opts.delete(:as) || opts.delete(:polymorphically)
          opts.delete(:polymorphically)

          suffix = opts.delete(:suffix) || 'class'
          
          opts[:child_key] = ["#{as}_id".to_sym]
          opts["#{as}_#{suffix}".to_sym] = self

          child_model_name = opts[:model] || opts[:class_name] || Extlib::Inflection.classify(name)
          child_klass      = Extlib::Inflection.constantize(child_model_name)
          belongs_to_name  = Extlib::Inflection.underscore(Extlib::Inflection.demodulize(self.name))

          has_without_polymorphism cardinality, name, *(args + [opts])
          child_klass.belongs_to "_#{as}_#{belongs_to_name}".to_sym, :child_key => opts[:child_key], :model => self
          child_klass.class_eval <<-EVIL, __FILE__, __LINE__+1
            def #{belongs_to_name}                                                          # def post
              _#{as}_#{belongs_to_name} if #{as}_#{suffix} == '#{self.name}'                #   _commentable_post if commentable_class == 'Post'
            end                                                                             # end
        
            def #{belongs_to_name}=(object)                                                 # def post=(object)
              self._#{as}_#{belongs_to_name} = object if #{as}_#{suffix} == '#{self.name}'  #   self._commentable_post = object if commentable_class == 'Post'
            end                                                                             # end
            
            protected :_#{as}_#{belongs_to_name}, :_#{as}_#{belongs_to_name}=
          EVIL
        else
          has_without_polymorphism(cardinality, name, *(args + [opts]))
        end
      end
      
      alias :belongs_to_without_polymorphism :belongs_to

      def belongs_to(name, *args)
        opts = args.last.kind_of?(::Hash) ? args.pop : {}
        if opts.delete(:polymorphic)
          suffix = opts.delete(:suffix) || 'class'
          
          property "#{name}_#{suffix}".to_sym, String
          property "#{name}_id".to_sym, Integer
          
          class_eval <<-EVIL, __FILE__, __LINE__+1
            def #{name}                                                                                                                   # def commentable
              send('_#{name}_' + Extlib::Inflection.underscore(Extlib::Inflection.demodulize(#{name}_#{suffix}))) if #{name}_#{suffix}    #   send('_commentable_' + Extlib::Inflection.underscore(Extlib::Inflection.demodulize(commentable_class))) if commentable_class
            end                                                                                                                           # end
        
            def #{name}=(object)                                                                                                          # def commentable=(object)
              self.#{name}_#{suffix} = object.class.name                                                                                  #   self.commentable_class = object.class.name
              self.send('_#{name}_' + Extlib::Inflection.underscore(Extlib::Inflection.demodulize(object.class.name)) + '=', object)      #   self.send('_commentable_' + Extlib::Inflection.underscore(Extlib::Inflection.demodulize(object.class.name)) + '=', object)
            end                                                                                                                           # end
          EVIL
        else
          belongs_to_without_polymorphism name, *(args + [opts])
        end
      end
    end
  end
end
