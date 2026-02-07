module AnalyticsPlane
  module Services
    class DatasetFetcher
      def self.fetch_chart_data(dataset, chart)
        adapter = AnalyticsPlane::Adapters::Registry.fetch(dataset.adapter)
        data_source = AnalyticsPlane::DataSources::Registry.fetch(dataset.slug)
        data = adapter.fetch_chart_data(data_source, chart)
      end

      def self.fetch_report_data(dataset, report)
        adapter = AnalyticsPlane::Adapters::Registry.fetch(dataset.adapter)
        data_source = AnalyticsPlane::DataSources::Registry.fetch(dataset.slug)
        data = adapter.fetch_report_data(data_source, report)
      end
    end
  end
end