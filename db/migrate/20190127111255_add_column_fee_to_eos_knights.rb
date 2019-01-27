class AddColumnFeeToEosKnights < ActiveRecord::Migration[5.0]
  def change
    add_column :eos_knights, :current_fee, :float, default: 0.03
  end
end
