class AddColumnsToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :active, :boolean, default: false
    add_column :requests, :completed, :boolean, default: false
  end
end
