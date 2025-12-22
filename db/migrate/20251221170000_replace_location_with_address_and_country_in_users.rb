class ReplaceLocationWithAddressAndCountryInUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :location, :string
    add_column :users, :address, :string
    add_column :users, :country, :string
  end
end
