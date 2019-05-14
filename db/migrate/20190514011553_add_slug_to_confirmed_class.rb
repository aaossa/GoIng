class AddSlugToConfirmedClass < ActiveRecord::Migration[5.2]
  def change
    add_column :confirmed_classes, :slug, :uuid, default: "gen_random_uuid()", null: false
  end
end
