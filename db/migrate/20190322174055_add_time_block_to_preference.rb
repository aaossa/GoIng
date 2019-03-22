class AddTimeBlockToPreference < ActiveRecord::Migration[5.2]
  def change
    add_reference :preferences, :time_block, foreign_key: true
  end
end
