class <%= class_name %>
  include AnalyticsPlane::DataSources::Base

  def self.dataset_key
    :<%= file_name %>
  end
end
