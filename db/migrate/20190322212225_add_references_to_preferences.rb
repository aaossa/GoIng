class AddReferencesToPreferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :preferences, :request, foreign_key: true
  end
end
