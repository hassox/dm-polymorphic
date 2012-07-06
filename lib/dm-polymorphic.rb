module DataMapper
  module Model
    module Relationship
      
      alias :resource_has :has
      
      def has(cardinality, name, *args)
        opts = args.last.kind_of?(::Hash) ? args.pop : {}
        if as = opts.delete(:as)

          suffix = opts.delete(:suffix) || 'class'
          
          opts[:child_key] = "#{as}_id".to_sym
          opts["#{as}_#{suffix}".to_sym] = self

          child_model_name = opts[:model] || opts[:class_name] || ActiveSupport::Inflector.classify(name)
          child_klass      = ActiveSupport::Inflector.constantize(child_model_name)
          belongs_to_name  = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self.name))

          resource_has cardinality, name, *(args + [opts])
          
          child_klass.belongs_to "_#{as}_#{belongs_to_name}".to_sym, :child_key => opts[:child_key], :model => self
          child_klass.class_eval <<-EVIL
            def #{belongs_to_name}                                                          # def post
              _#{as}_#{belongs_to_name} if #{as}_#{suffix} == '#{self.name}'                #   _commentable_post if commentable_class == 'Post'
            end                                                                             # end
                  
            def #{belongs_to_name}=(object)                                                 # def post=(object)
              self._#{as}_#{belongs_to_name} = object if #{as}_#{suffix} == '#{self.name}'  #   self._commentable_post = object if commentable_class == 'Post'
            end                                                                             # end
            
            protected :_#{as}_#{belongs_to_name}, :_#{as}_#{belongs_to_name}=
          EVIL
        else
          resource_has cardinality, name, *(args + [opts])
        end
      end
      
      alias :resource_belongs_to :belongs_to

      def belongs_to(name, *args)
        opts = args.last.kind_of?(::Hash) ? args.pop : {}
        if opts.delete(:polymorphic)
          suffix = opts.delete(:suffix) || 'class'
          
          property "#{name}_#{suffix}".to_sym, String
          
          class_eval <<-EVIL
            def #{name}                                                                                                                               # def commentable
              send('_#{name}_' + ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(#{name}_#{suffix}))) if #{name}_#{suffix}    #   send('_commentable_' + ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(commentable_class))) if commentable_class
            end                                                                                                                                       # end
        
            def #{name}=(object)                                                                                                                      # def commentable=(object)
              self.#{name}_#{suffix} = object.class.name                                                                                              #   self.commentable_class = object.class.name
              self.send('_#{name}_' + ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(object.class.name)) + '=', object)      #   self.send('_commentable_' + ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(object.class.name)) + '=', object)
            end                                                                                                                                       # end
          EVIL
        else
          resource_belongs_to name, *(args + [opts])
        end
      end
    end
  end
end
