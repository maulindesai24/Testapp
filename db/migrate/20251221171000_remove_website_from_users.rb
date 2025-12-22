class RemoveWebsiteFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :website, :string
  end
end
