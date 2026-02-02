module Fios
  module Registrar
    def self.register(&block)
      instance_eval(&block)
    end

    def self.dataset(klass)
      Fios::Definitions::Registry.register(klass)
    end

    def self.adapter(klass)
      Fios::Adapters::Registry.register(klass)
    end
  end
end
