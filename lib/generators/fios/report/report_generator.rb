require "rails/generators"
require "rails/generators/named_base"
require "rails/generators/migration"

module Fios
  module Generators
    class ReportGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __dir__)

      desc "Creates a Report model and migration for Fios"

      def create_model
        template "report_model.rb", "app/models/#{file_name}.rb"
      end

      def create_report_migration
        migration_template(
          "create_reports.rb",
          "db/migrate/create_#{file_name.pluralize}.rb"
        )
      end

      def self.next_migration_number(dirname)
        if @next_migration_number
          @next_migration_number += 1
        else
          @next_migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
        end
      end
    end
  end
end
