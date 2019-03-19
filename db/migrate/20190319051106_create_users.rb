class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :google_name
      t.string :google_email
      t.string :google_image
      t.string :google_token

      t.timestamps
    end
  end
end
