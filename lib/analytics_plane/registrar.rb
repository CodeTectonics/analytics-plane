module AnalyticsPlane
  module Registrar
    def self.register(&block)
      instance_eval(&block)
    end

    def self.data_source(klass)
      AnalyticsPlane::DataSources::Registry.register(klass)
    end

    def self.adapter(klass)
      AnalyticsPlane::Adapters::Registry.register(klass)
    end
  end
end
