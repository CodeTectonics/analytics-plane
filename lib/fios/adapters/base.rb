module Fios
  module Adapters
    module Base
      extend ActiveSupport::Concern

      attr_accessor :dataset, :definition

      class_methods do
        def adapter_key
          raise NotImplementedError
        end
      end

      def fetch(filters:, limit:)
        raise NotImplementedError
      end
    end
  end
end
