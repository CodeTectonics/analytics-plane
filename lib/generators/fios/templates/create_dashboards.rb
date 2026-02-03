class Create<%= class_name.pluralize %> < ActiveRecord::Migration[7.0]
  def change
    create_table :<%= file_name.pluralize %> do |t|
      t.string :name
      t.timestamps
    end
  end
end
