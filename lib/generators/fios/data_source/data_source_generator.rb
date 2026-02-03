require "rails/generators"
require "rails/generators/named_base"

module Fios
  module Generators
    class DataSourceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __dir__)

      desc "Creates a Fios dataset definition"

      def create_data_source
        template "data_source.rb", "app/datasets/#{file_name}.rb"
      end
    end
  end
end
