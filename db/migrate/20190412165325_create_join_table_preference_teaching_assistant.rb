class CreateJoinTablePreferenceTeachingAssistant < ActiveRecord::Migration[5.2]
  def change
    create_join_table :preferences, :teaching_assistants do |t|
      # t.index [:preference_id, :teaching_assistant_id]
      # t.index [:teaching_assistant_id, :preference_id]
    end
  end
end
