require "rails/generators"
require "rails/generators/named_base"
require "rails/generators/migration"

module AnalyticsPlane
  module Generators
    class DashboardGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __dir__)

      desc "Creates a Dashboard model, Dashboard Widget model, and migrations for AnalyticsPlane"

      def create_dashboard_model
        template "dashboard_model.rb", "app/models/#{file_name}.rb"
      end

      def create_widget_model
        template "dashboard_widget_model.rb", "app/models/#{file_name}_widget.rb"
      end

      def create_dashboard_migration
        migration_template(
          "create_dashboards.rb",
          "db/migrate/create_#{file_name.pluralize}.rb"
        )
      end

      def create_widget_migration
        migration_template(
          "create_dashboard_widgets.rb",
          "db/migrate/create_#{file_name.pluralize}_widget.rb"
        )
      end

      def self.next_migration_number(dirname)
        @next_migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end
