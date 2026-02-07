module AnalyticsPlane
  module Adapters
    class ActiveRecordAdapter
      include AnalyticsPlane::Adapters::Base

      def self.adapter_key
        :active_record
      end

      def self.fetch_chart_data(data_source, chart)
        chart_config = chart.configuration

        query = data_source.all
        query = AnalyticsPlane::Adapters::ActiveRecord::ChartQuery.add_select_clause(query, chart_config)
        query = AnalyticsPlane::Adapters::ActiveRecord::ChartQuery.add_where_clause(query, chart_config)
        query = AnalyticsPlane::Adapters::ActiveRecord::ChartQuery.add_group_clause(query, chart_config)
        data = query.to_a

        {
          series: AnalyticsPlane::Adapters::ActiveRecord::ChartQuery.parse_series_data(data, chart_config),
          categories: AnalyticsPlane::Adapters::ActiveRecord::ChartQuery.parse_category_data(data, chart_config, data_source),
          meta: {
            title: chart.name,
            chart_type: chart_config['chart_type']
          }
        }
      end

      def self.fetch_report_data(data_source, report)
        report_config = report.configuration

        query = data_source.all
        query = AnalyticsPlane::Adapters::ActiveRecord::ReportQuery.add_select_clause(query, data_source, report_config)
        query = AnalyticsPlane::Adapters::ActiveRecord::ReportQuery.add_where_clause(query, report_config)
        AnalyticsPlane::Adapters::ActiveRecord::ReportQuery.add_group_clause(query, report_config)
      end
    end
  end
end