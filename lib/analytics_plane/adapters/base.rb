module AnalyticsPlane
  module Adapters
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def adapter_key
          raise NotImplementedError
        end

        def fetch_chart_data(data_source, chart)
          raise NotImplementedError
        end

        def fetch_report_data(data_source, report)
          raise NotImplementedError
        end
      end
    end
  end
end
