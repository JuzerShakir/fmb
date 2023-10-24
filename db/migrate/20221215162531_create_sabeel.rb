class CreateSabeel < ActiveRecord::Migration[7.0]
  def change
    create_table :sabeels do |t|
      t.integer :its, null: false, index: {unique: true}
      t.string :name, null: false
      t.integer :apartment, null: false
      t.integer :flat_no, null: false
      t.string :address, null: false
      t.integer :mobile, limit: 8, null: false
      t.string :email
      t.string :slug, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
