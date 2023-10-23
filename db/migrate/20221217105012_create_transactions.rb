class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :thaali_takhmeen, null: false, foreign_key: true
      t.integer :recipe_no, null: false, default: 1, index: {unique: true}
      t.integer :mode, null: false
      t.integer :amount, null: false
      t.date :date, null: false
      t.string :slug, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
