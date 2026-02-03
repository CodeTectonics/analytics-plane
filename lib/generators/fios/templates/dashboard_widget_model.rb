class <%= class_name %>Widget < ApplicationRecord
  store_accessor :layout, :pos_x, :pos_y, :width, :height

  belongs_to :dashboard
end
