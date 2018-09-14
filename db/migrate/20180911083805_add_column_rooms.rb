class AddColumnRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :login_id, :string, null: false
    add_column :rooms, :password_digest, :string, null: false
    add_column :rooms, :remember_token, :string, null: false
    add_column :rooms, :admin, :boolean, null: false
  end
end
