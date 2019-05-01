class CreateJoinTablePreferenceRequest < ActiveRecord::Migration[5.2]
  def change
    create_join_table :preferences, :requests do |t|
      # t.index [:preference_id, :request_id]
      # t.index [:request_id, :preference_id]
    end
  end
end
