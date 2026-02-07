module AnalyticsPlane
  module Builders
    class ChartBuilder
      def self.build(chart)
        data = fetch_data(chart)
        parse_query_results(data)
      end

      def self.fetch_data(chart)
        chart_config = chart.configuration || {}
        dataset = Dataset.find(chart_config['dataset_id'])
        AnalyticsPlane::Services::DatasetFetcher.fetch_chart_data(dataset, chart)
      end

      def self.parse_query_results(data)
        {
          'chart': {
            'type': data[:meta][:chart_type]
          },

          'title': {
            'text': data[:meta][:title]
          },

          'xAxis': {
            'categories': data[:categories]
          },

          'yAxis': {
            'title': {
              'text': nil
            }
          },

          'series': data[:series]
        }
      end

      def self.build_csv(chart)
        {
          headers: csv_headers(chart),
          rows: fetch_data(chart)
        }
      end

      def self.csv_headers(chart)
        chart_config = chart.configuration || {}

        fields = []
        fields << chart_config['x_axis']['attr']

        chart_config['y_axes'].each do |column|
          fields << "num_#{column['attr']}" if column['count']
          fields << "num_uniq_#{column['attr']}" if column['count_distinct']
          fields << "avg_#{column['attr']}" if column['average']
          fields << "min_#{column['attr']}" if column['min']
          fields << "max_#{column['attr']}" if column['max']
          fields << "sum_#{column['attr']}" if column['sum']
        end

        fields
      end
    end
  end
end
