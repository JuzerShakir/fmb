class CreateThaalis < ActiveRecord::Migration[7.0]
  def change
    create_table :thaalis do |t|
      t.references :sabeel, null: false, foreign_key: true
      t.integer :year, null: false
      t.integer :total, null: false
      t.integer :number, null: false
      t.integer :size, null: false
      t.string :slug, null: false, index: {unique: true}

      t.timestamps
    end

    add_index :thaalis, [:year, :sabeel_id], unique: true
  end
end
