module AnalyticsPlane
  module Builders
    class ReportBuilder
      def self.build(report)
        fetch_data(report)
      end

      def self.fetch_data(report)
        report_config = report.configuration || {}
        dataset = Dataset.find(report_config['dataset_id'])
        AnalyticsPlane::Services::DatasetFetcher.fetch_report_data(dataset, report)
      end

      def self.build_csv(report)
        {
          headers: csv_headers(report),
          rows: fetch_data(report)
        }
      end

      def self.csv_headers(report)
        report_config = report.configuration || {}

        dataset = Dataset.find(report_config['dataset_id'])
        dataset_class = AnalyticsPlane::Services::DatasetFetcher.fetch_report_data(dataset, report)

        return dataset_class.column_names if report_config['columns'].blank?

        fields = []
        report_config['columns'].each do |column|
          next unless column['selected']

          if report_config['aggregated']
            fields << column['name'] if column['group_by']
            fields << "num_#{column['name']}" if column['count']
            fields << "num_uniq_#{column['name']}" if column['count_distinct']
            fields << "avg_#{column['name']}" if column['average']
            fields << "min_#{column['name']}" if column['min']
            fields << "max_#{column['name']}" if column['max']
            fields << "sum_#{column['name']}" if column['sum']
          else
            fields << column['name']
          end
        end

        fields
      end
    end
  end
end
