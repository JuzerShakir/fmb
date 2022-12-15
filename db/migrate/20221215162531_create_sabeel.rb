class CreateSabeel < ActiveRecord::Migration[7.0]
  def change
    create_table :sabeels do |t|
      t.integer :its
      t.string :hof_name
      t.string :address
      t.integer :mobile, limit: 8
      t.string :email
      t.boolean :takes_thaali

      t.timestamps
    end
    add_index :sabeels, :its, unique: true
    add_index :sabeels, :hof_name, unique: true
  end
end
