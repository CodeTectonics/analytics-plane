Rails.application.config.to_prepare do
  AnalyticsPlane::Registrar.register do
    # adapter AnalyticsPlane::Adapters::ActiveRecordAdapter
    # data_source EmployeesDataSource
  end
end
