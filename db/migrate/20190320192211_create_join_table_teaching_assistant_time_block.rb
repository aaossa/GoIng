class CreateJoinTableTeachingAssistantTimeBlock < ActiveRecord::Migration[5.2]
  def change
    create_join_table :teaching_assistants, :time_blocks do |t|
      # t.index [:teaching_assistant_id, :time_block_id]
      # t.index [:time_block_id, :teaching_assistant_id]
    end
  end
end
