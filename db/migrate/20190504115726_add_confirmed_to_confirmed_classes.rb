class AddConfirmedToConfirmedClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :confirmed_classes, :confirmed, :boolean, default: false
  end
end
