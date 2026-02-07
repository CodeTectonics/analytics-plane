module AnalyticsPlane
  module DataSources
    class Registry
      mattr_accessor :data_sources, default: {}

      def self.register(klass)
        key = klass.dataset_key.to_sym
        raise "Duplicate dataset key: #{key}" if data_sources.key?(key)

        @data_sources[key] = klass
      end

      def self.fetch(key)
        @data_sources.fetch(key.to_sym) do
          raise KeyError, "Unknown dataset: #{key}"
        end
      end

      def self.clear!
        @data_sources = {}
      end
    end
  end
end
