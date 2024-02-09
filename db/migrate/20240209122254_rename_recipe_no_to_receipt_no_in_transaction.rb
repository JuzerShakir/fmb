class RenameRecipeNoToReceiptNoInTransaction < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :recipe_no, :receipt_number
  end
end
