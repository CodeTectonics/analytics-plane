module AnalyticsPlane
  module DataSources
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def dataset_key
          raise NotImplementedError
        end
      end
    end
  end
end
