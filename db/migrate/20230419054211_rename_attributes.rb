class RenameAttributes < ActiveRecord::Migration[7.0]
  def change
    change_table :sabeels do |t|
      t.rename(:hof_name, :name)
    end

    change_table :transactions do |t|
      t.rename(:on_date, :date)
    end
  end
end
