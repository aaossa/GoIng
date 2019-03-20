class CreateTimeBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :time_blocks do |t|
      t.integer :day
      t.time :start
      t.time :finish

      t.timestamps
    end
  end
end
