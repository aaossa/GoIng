class AddUniqueIndexToPreferences < ActiveRecord::Migration[5.2]
  def change
  	add_index :preferences, [:request_id, :date, :time_block_id], unique: true
  end
end
