class CreateTeachingAssistants < ActiveRecord::Migration[5.2]
  def change
    create_table :teaching_assistants do |t|
      t.string :name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
