class CreateTakhmeens < ActiveRecord::Migration[7.0]
  def change
    create_table :takhmeens do |t|
      t.references :thaali, null: false, foreign_key: true
      t.integer :year, null: false, default: 2022
      t.integer :total, null: false
      t.integer :paid, null: false, default: 0
      t.integer :balance, null: false
      t.boolean :is_complete, null: false, default: false

      t.timestamps
    end

    add_index :takhmeens, [:year, :thaali_id], unique: true
  end
end
