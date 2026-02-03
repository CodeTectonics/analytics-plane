class <%= class_name %> < ApplicationRecord
  store_accessor :configuration, :dataset_id, :aggregated, :columns, :filters

  validates :name, presence: true, uniqueness: true
end
