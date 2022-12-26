class AddSlugToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :slug, :string
    add_index :transactions, :slug, unique: true
  end
end
