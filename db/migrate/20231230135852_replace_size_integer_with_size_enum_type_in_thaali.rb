class ReplaceSizeIntegerWithSizeEnumTypeInThaali < ActiveRecord::Migration[7.1]
  def change
    sizes = %w[Small Medium Large]
    create_enum :sizes, sizes

    add_column :thaalis, :size_enum, :enum, enum_type: :sizes, default: "Small", null: false

    reversible do |direction|
      # rubocop:disable Rails/SkipsModelValidations
      direction.up do
        sizes.each_with_index do |size, i|
          Thaali.where(size: i).update_all(size_enum: size)
        end
      end

      direction.down do
        sizes.each_with_index do |size, i|
          Thaali.where(size_enum: size).update_all(size: i)
        end
        # to access `#size` data, update the enum value of it in `app/models/thaalis` file:
        # enum size: SIZES
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    remove_column :thaalis, :size, :integer
    rename_column :thaalis, :size_enum, :size
  end
end
