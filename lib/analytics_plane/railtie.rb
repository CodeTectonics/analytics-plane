module AnalyticsPlane
  class Railtie < Rails::Railtie
    initializer "analytics_plane.prepare" do
      Rails.application.config.to_prepare do
        AnalyticsPlane::DataSources::Registry.clear!
        AnalyticsPlane::Adapters::Registry.clear!
      end
    end
  end
end
