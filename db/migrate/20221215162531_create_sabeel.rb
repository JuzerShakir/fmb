class CreateSabeel < ActiveRecord::Migration[7.0]
  def change
    create_table :sabeels do |t|
      t.integer :its, null: false
      t.string :hof_name, null: false
      t.integer :apartment, null: false
      t.string :wing, null: false
      t.integer :flat_no, null: false
      t.string :address, null: false
      t.integer :mobile, limit: 8, null: false
      t.string :email
      t.boolean :takes_thaali, default: false, null: false

      t.timestamps
    end
    add_index :sabeels, :its, unique: true
    add_index :sabeels, [:hof_name, :its], unique: true
  end
end
