module Fios
  module Adapters
    class ActiveRecordAdapter
      include Fios::Adapters::Base

      def self.adapter_key
        :active_record
      end

      def initialize(dataset)
        @dataset = dataset
        @definition = Fios::Definitions::Registry.fetch(dataset.slug)
      end

      # TODO
      def fetch(filters:, limit:)
        view = @definition.source
        # build SQL using filters + metadata
      end
    end
  end
end