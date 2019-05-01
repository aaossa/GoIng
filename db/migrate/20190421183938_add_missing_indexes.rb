class AddMissingIndexes < ActiveRecord::Migration[5.2]
  # https://github.com/plentz/lol_dba/blob/master/README.md#quick-example
  def change
    add_index :courses_teaching_assistants, :course_id
    add_index :courses_teaching_assistants, :teaching_assistant_id
    add_index :courses_teaching_assistants, [:course_id, :teaching_assistant_id], name: 'course and TA index'
    add_index :identities, :user_id
    add_index :preferences_requests, :preference_id
    add_index :preferences_requests, :request_id
    add_index :preferences_requests, [:preference_id, :request_id]
    add_index :preferences_teaching_assistants, :preference_id
    add_index :preferences_teaching_assistants, :teaching_assistant_id
    add_index :teaching_assistants_time_blocks, :teaching_assistant_id
    add_index :teaching_assistants_time_blocks, :time_block_id
    add_index :teaching_assistants_time_blocks, [:teaching_assistant_id, :time_block_id], name: 'TA and block index'
  end
end
