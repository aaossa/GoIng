class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.integer :participants
      t.text :contents

      t.timestamps
    end
  end
end
