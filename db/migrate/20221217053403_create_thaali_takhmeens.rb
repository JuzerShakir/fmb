class CreateThaaliTakhmeens < ActiveRecord::Migration[7.0]
  def change
    create_table :thaali_takhmeens do |t|
      t.references :sabeel, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :total, null: false
      t.integer :paid, null: false, default: 0
      t.integer :balance, null: false
      t.boolean :is_complete, null: false, default: false
      t.integer :number, null: false
      t.integer :size, null: false
      t.string :slug, null: false, index: {unique: true}

      t.timestamps
    end

    add_index :thaali_takhmeens, [:year, :sabeel_id], unique: true
    add_index :thaali_takhmeens, [:year, :number], unique: true
  end
end
