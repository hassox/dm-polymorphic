module DataMapper
  module Types
    class Class < DataMapper::Type
      primitive String

      def self.load(value, property)
        value.nil? ? nil : Extlib::Inflection.constantize(value)
      end

      def self.dump(value, property)
        value.nil? ? nil : value.name
      end
    end # class URI
  end # module Types
end # module DataMapper
