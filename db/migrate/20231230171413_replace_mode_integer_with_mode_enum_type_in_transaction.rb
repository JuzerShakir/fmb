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
        # make sure to update the MODES constant value in order to access the 'mode' data
        # MODES = %i[cash cheque bank]
      end
      # rubocop:enable Rails/SkipsModelValidations
    end

    remove_column :transactions, :mode, :integer
    rename_column :transactions, :mode_enum, :mode
  end
end
