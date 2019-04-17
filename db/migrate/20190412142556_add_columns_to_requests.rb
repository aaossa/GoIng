class AddColumnsToRequests < ActiveRecord::Migration[5.2]
  def change
  	# Active: Looking for TA to assign
    add_column :requests, :active, :boolean, default: false
    # Assigned: Found a TA, class is confirmed
    add_column :requests, :assigned, :boolean, default: false
    # Completed: Class already done (save evaluation)
    add_column :requests, :completed, :boolean, default: false
  end
end
