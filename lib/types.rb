module DataMapper
  module Types
    class Klass < DataMapper::Type
      primitive Class

      def self.load(value, property)
        if value
          value # value.is_a?(Class) ? value : Extlib::Inflection.constantize(value)
        else
          nil
        end
      end

      def self.dump(value, property)
        if value
          (value.is_a? Class) ? value.name : Extlib::Inflection.constantize(value.to_s)
        else
          nil
        end
      end
    end # class URI
  end # module Types
end # module DataMapper
