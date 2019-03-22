class CreatePreferences < ActiveRecord::Migration[5.2]
  def change
    create_table :preferences do |t|
      t.date :date
      t.integer :priority

      t.timestamps
    end
  end
end
