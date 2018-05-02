class CreateTobanhyos < ActiveRecord::Migration[5.0]
  def change
    create_table :tobanhyos do |t|
      t.integer :room_id
      t.integer :role_id
      t.boolean :fixed
      t.timestamps
    end
  end
end
