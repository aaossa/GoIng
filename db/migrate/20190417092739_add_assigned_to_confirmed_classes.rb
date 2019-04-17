class AddAssignedToConfirmedClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :confirmed_classes, :assigned, :boolean, default: false
  end
end
