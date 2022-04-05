class AddFormatToRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :format, :string
  end
end
