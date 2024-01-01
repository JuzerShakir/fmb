class ReplaceModeIntegerWithModeEnumTypeInTransaction < ActiveRecord::Migration[7.1]
  def change
    modes = %w[Cash Cheque Bank]
    create_enum :modes, modes

    add_column :transactions, :mode_enum, :enum, enum_type: :modes, default: "Cash", null: false

    reversible do |direction|
      # rubocop:disable Rails/SkipsModelValidations
      direction.up do
        modes.each_with_index do |mode, i|
          Transaction.where(mode: i).update_all(mode_enum: mode)
        end
      end

      direction.down do
        modes.each_with_index do |mode, i|
          Transaction.where(mode_enum: mode).update_all(mode: i)
        end
        # to access `#mode` data, update the enum value of it in `app/models/transactions` file:
        # enum mode: MODES
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    remove_column :transactions, :mode, :integer
    rename_column :transactions, :mode_enum, :mode
  end
end
