Rails.application.config.to_prepare do
  Fios::Registrar.register do
    # adapter Fios::Adapters::ActiveRecordAdapter
    # dataset EmployeesDataSource
  end
end
