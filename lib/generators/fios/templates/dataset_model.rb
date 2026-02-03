class <%= class_name %> < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :adapter, presence: true
end
