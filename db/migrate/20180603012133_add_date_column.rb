class AddDateColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :tobanhyos, :start_of_period, :date
  end
end
