require "rails/generators"

module AnalyticsPlane
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc "Installs AnalyticsPlane and creates the initializer"

      def create_initializer
        template "analytics_plane_initializer.rb", "config/initializers/analytics_plane.rb"
      end
    end
  end
end
