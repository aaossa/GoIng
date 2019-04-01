class AddConfirmedClassToRequest < ActiveRecord::Migration[5.2]
  def change
    add_reference :requests, :confirmed_class, foreign_key: true
  end
end
