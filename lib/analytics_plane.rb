# frozen_string_literal: true

require "active_support"
require "active_support/concern"
require "rails"

require_relative "analytics_plane/adapters/base"
require_relative "analytics_plane/adapters/active_record/chart_query"
require_relative "analytics_plane/adapters/active_record/report_query"
require_relative "analytics_plane/adapters/active_record_adapter"
require_relative "analytics_plane/adapters/registry"
require_relative "analytics_plane/builders/chart_builder"
require_relative "analytics_plane/builders/report_builder"
require_relative "analytics_plane/data_sources/base"
require_relative "analytics_plane/data_sources/registry"
require_relative "analytics_plane/services/dataset_fetcher"
require_relative "analytics_plane/registrar"
require_relative "analytics_plane/version"
require_relative "analytics_plane/railtie"

module AnalyticsPlane
  class Error < StandardError; end
end
