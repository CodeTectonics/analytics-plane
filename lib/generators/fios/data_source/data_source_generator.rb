require "rails/generators"
require "rails/generators/named_base"

module AnalyticsPlane
  module Generators
    class DataSourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __dir__)

      desc "Creates a AnalyticsPlane data source"

      def create_data_source
        template "data_source.rb", "app/datasets/#{file_name}.rb"
      end
    end
  end
end
