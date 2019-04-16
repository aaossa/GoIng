class CreateJoinTablePreferenceTeachingAssistant < ActiveRecord::Migration[5.2]
  def change
    create_join_table :preferences, :teaching_assistants do |t|
      # t.index [:preference_id, :teaching_assistant_id]
      # t.index [:teaching_assistant_id, :preference_id]
    end

	add_index :preferences_teaching_assistants,
		[:preference_id, :teaching_assistant_id],
		unique: true,
		name: 'prevent_unavailable_duplicates_1'
	add_index :preferences_teaching_assistants,
		[:teaching_assistant_id, :preference_id],
		unique: true,
		name: 'prevent_unavailable_duplicates_2'
  end
end
