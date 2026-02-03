class <%= class_name %> < ApplicationRecord
  has_many :dashboard_widgets, dependent: :destroy

  accepts_nested_attributes_for :dashboard_widgets, allow_destroy: true

  validates :name, presence: true, uniqueness: true
end
