class AddPriorityToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :priority, :integer, default: 1
  end
end
