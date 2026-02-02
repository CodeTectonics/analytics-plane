# frozen_string_literal: true

require "active_support"
require "active_support/concern"
require "rails"

require_relative "fios/adapters/base"
require_relative "fios/adapters/active_record_adapter"
require_relative "fios/adapters/registry"
require_relative "fios/builders/chart_builder"
require_relative "fios/builders/report_builder"
require_relative "fios/definitions/base"
require_relative "fios/definitions/registry"
require_relative "fios/services/dataset_fetcher"
require_relative "fios/registrar"
require_relative "fios/version"
require_relative "fios/railtie"

module Fios
  class Error < StandardError; end
end
