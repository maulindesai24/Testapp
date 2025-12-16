class AddRoleIdToUsers < ActiveRecord::Migration[8.1]
  def up
    # Add role_id column (nullable initially to allow data migration)
    add_reference :users, :role, null: true, foreign_key: true
    
    execute <<-SQL
      UPDATE users
      SET role_id = (SELECT id FROM roles WHERE LOWER(roles.name) = LOWER(users.role))
      WHERE role IS NOT NULL;
    SQL
    
    # Set default role for users without a role
    execute <<-SQL
      UPDATE users
      SET role_id = (SELECT id FROM roles WHERE LOWER(roles.name) = 'user' LIMIT 1)
      WHERE role_id IS NULL;
    SQL
    
    # Now make role_id required
    change_column_null :users, :role_id, false
    
    # Remove the old role string column
    remove_column :users, :role, :string
  end

  def down
    # Add back the role column
    add_column :users, :role, :string, default: 'user', null: false
    
    # Migrate role_id back to role string
    execute <<-SQL
      UPDATE users
      SET role = (SELECT name FROM roles WHERE roles.id = users.role_id)
      WHERE role_id IS NOT NULL;
    SQL
    
    # Remove role_id column
    remove_reference :users, :role, foreign_key: true
  end
end
