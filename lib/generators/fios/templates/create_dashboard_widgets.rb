class Create<%= class_name %>Widgets < ActiveRecord::Migration[7.0]
  def change
    create_table :<%= file_name %>_widgets do |t|
      t.references :dashboard, foreign_key: true
      t.json :layout, null: false, default: {}
      t.timestamps
    end
  end
end
