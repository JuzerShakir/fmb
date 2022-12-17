class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :takhmeen, null: false, foreign_key: true
      t.integer :mode, null: false
      t.integer :amount, null: false
      t.date :on_date, null: false

      t.timestamps
    end
  end
end
