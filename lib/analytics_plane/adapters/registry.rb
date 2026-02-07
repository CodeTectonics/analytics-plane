module AnalyticsPlane
  module Adapters
    class Registry
      mattr_accessor :adapters, default: {}

      def self.register(klass)
        key = klass.adapter_key.to_sym
        raise "Duplicate dataset adapter key: #{key}" if @adapters.key?(key)
        @adapters[key] = klass
      end

      def self.fetch(key)
        @adapters.fetch(key.to_sym) do
          raise KeyError, "Unknown dataset adapter: #{key}"
        end
      end

      def self.clear!
        @adapters = {}
      end
    end
  end
end
