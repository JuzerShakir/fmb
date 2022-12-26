class AddSlugToThaaliTakhmeen < ActiveRecord::Migration[7.0]
  def change
    add_column :thaali_takhmeens, :slug, :string
    add_index :thaali_takhmeens, :slug, unique: true
  end
end
