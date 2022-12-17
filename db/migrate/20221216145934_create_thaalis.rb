class CreateThaalis < ActiveRecord::Migration[7.0]
  def change
    create_table :thaalis do |t|
      t.integer :number, null: false
      t.integer :size, null: false
      t.references :sabeel, null: false, foreign_key: true, index: {unique: true}

      t.timestamps
    end
    add_index :thaalis, :number, unique: true
  end
end
