class Create<%= class_name.pluralize %> < ActiveRecord::Migration[7.0]
  def change
    create_table :<%= file_name.pluralize %> do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.text :description
      t.string :adapter, null: false
      t.timestamps
    end
  end
end
