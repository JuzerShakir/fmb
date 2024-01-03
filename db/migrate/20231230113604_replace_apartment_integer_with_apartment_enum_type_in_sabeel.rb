class ReplaceApartmentIntegerWithApartmentEnumTypeInSabeel < ActiveRecord::Migration[7.1]
  def change
    apartments = ["Mohammedi", "Taiyebi", "Burhani", "Maimoon A", "Maimoon B"]
    create_enum :apartments, apartments

    add_column :sabeels, :apartment_enum, :enum, enum_type: :apartments, default: "Mohammedi", null: false

    reversible do |direction|
      # rubocop:disable Rails/SkipsModelValidations
      direction.up do
        apartments.each_with_index do |apartment, i|
          Sabeel.where(apartment: i).update_all(apartment_enum: apartment)
        end
      end

      direction.down do
        apartments.each_with_index do |apartment, i|
          Sabeel.where(apartment_enum: apartment).update_all(apartment: i)
        end
        # to access `#apartment` data, update the enum value of it in `app/models/sabeels` file:
        # enum apartment: APARTMENTS
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    remove_column :sabeels, :apartment, :integer
    rename_column :sabeels, :apartment_enum, :apartment
  end
end
