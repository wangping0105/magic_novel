class CreateEosMinings < ActiveRecord::Migration[5.0]
  def change
    create_table :eos_minings do |t|
      t.integer :eos_user_id, index: true
      t.string  :referrer
      t.string  :transaction_id
      t.float  :account
      t.string  :from
      t.string  :to
      t.string  :quantity
      t.text  :memo
      t.string  :category, limit: 50, index: true

      t.timestamps
    end
  end
end
