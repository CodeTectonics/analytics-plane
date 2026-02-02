module Fios
  module Services
    class DatasetFetcher
      def self.fetch(dataset)
        adapter_klass = Fios::Adapters::Registry.fetch(dataset.adapter)
        adapter = adapter_klass.new(dataset)
        adapter.definition
        #adapter.fetch()
      end
    end
  end
end