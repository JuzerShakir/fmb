class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :its, null: false, index: {unique: true}
      t.string :name, null: false
      t.string :password_digest, null: false
      t.string :slug, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
