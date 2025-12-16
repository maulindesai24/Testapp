class ChangeRoleToStringInUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :role, :integer
    add_column :users, :role, :string, default: 'user', null: false
  end
end
