class AddIndexesToUserRoles < ActiveRecord::Migration
  disable_ddl_transaction!
  def change
    add_index :user_roles, [:user_id, :role_id], algorithm: :concurrently
    add_index :user_roles, :user_id, algorithm: :concurrently
    add_index :user_roles, :role_id, algorithm: :concurrently
  end
end
