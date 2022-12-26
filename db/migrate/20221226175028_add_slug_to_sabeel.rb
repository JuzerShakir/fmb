class AddSlugToSabeel < ActiveRecord::Migration[7.0]
  def change
    add_column :sabeels, :slug, :string
    add_index :sabeels, :slug, unique: true
  end
end
