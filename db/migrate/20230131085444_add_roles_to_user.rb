class AddRolesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, null: false
  end
end
