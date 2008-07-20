module DataMapper
  module Types
    class Class < DataMapper::Type
      primitive String

      def self.load(value, property)
        value.nil? ? nil : Extlib::Inflection.constantize(value)
      end

      def self.dump(value, property)
        if value
          (value.is_a? Class) ? value : Extlib::Inflection.constantize(value)
        else
          nil
        end
      end
    end # class URI
  end # module Types
end # module DataMapper
