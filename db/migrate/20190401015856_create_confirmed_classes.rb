class CreateConfirmedClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :confirmed_classes do |t|
      t.references :teaching_assistant, foreign_key: true
      t.references :preference, foreign_key: true

      t.timestamps
    end
  end
end
