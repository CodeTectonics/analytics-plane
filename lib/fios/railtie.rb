module Fios
  class Railtie < Rails::Railtie
    initializer "fios.prepare" do
      Rails.application.config.to_prepare do
        Fios::Definitions::Registry.clear!
        Fios::Adapters::Registry.clear!
      end
    end
  end
end
