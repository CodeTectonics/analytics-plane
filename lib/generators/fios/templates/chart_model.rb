class <%= class_name %> < ApplicationRecord
  store_accessor :configuration, :chart_type, :dataset_id, :x_axis, :y_axes, :filters

  validates :name, presence: true, uniqueness: true
end
