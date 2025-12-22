class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :bio, :text
    add_column :users, :phone, :string
    add_column :users, :location, :string
    add_column :users, :website, :string
  end
end

