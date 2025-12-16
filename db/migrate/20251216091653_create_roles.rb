class CreateRoles < ActiveRecord::Migration[8.1]
  def up
    create_table :roles do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end

    add_index :roles, :name, unique: true

    # Create default roles using SQL to avoid model dependencies
    execute <<-SQL
      INSERT INTO roles (name, description, created_at, updated_at)
      VALUES 
        ('user', 'Standard user role with basic permissions', NOW(), NOW()),
        ('admin', 'Administrator role with full system access', NOW(), NOW());
    SQL
  end

  def down
    drop_table :roles
  end
end
