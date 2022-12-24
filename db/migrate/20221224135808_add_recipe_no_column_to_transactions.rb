class AddRecipeNoColumnToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :recipe_no, :integer, null: false
    add_index :transactions, :recipe_no
  end
end
