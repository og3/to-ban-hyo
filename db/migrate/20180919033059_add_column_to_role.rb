class AddColumnToRole < ActiveRecord::Migration[5.0]
  def change
    add_column :roles, :memo, :text
  end
end
