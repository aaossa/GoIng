class CreateJoinTableCourseTeachingAssistant < ActiveRecord::Migration[5.2]
  def change
    create_join_table :courses, :teaching_assistants do |t|
      # t.index [:course_id, :teaching_assistant_id]
      # t.index [:teaching_assistant_id, :course_id]
    end
  end
end
