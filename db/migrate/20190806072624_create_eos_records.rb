class CreateEosRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :eos_records do |t|
      t.integer :eos_user_id, index: true
      t.integer :types, default: 0
      t.float :quantity
      t.string :memo
      t.string :code
      t.string :symbol

      t.timestamps
    end
  end
end
