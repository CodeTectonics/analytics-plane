require "rails/generators"

module Fios
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc "Installs Fios and creates the initializer"

      def create_initializer
        template "fios_initializer.rb", "config/initializers/fios.rb"
      end
    end
  end
end
