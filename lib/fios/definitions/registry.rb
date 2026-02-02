module Fios
  module Definitions
    class Registry
      mattr_accessor :definitions, default: {}

      def self.register(klass)
        key = klass.dataset_key.to_sym
        raise "Duplicate dataset key: #{key}" if definitions.key?(key)

        @definitions[key] = klass
      end

      def self.fetch(key)
        @definitions.fetch(key.to_sym) do
          raise KeyError, "Unknown dataset: #{key}"
        end
      end

      def self.clear!
        @definitions = {}
      end
    end
  end
end
