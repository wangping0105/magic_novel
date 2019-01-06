class CreateEosKnights < ActiveRecord::Migration[5.0]
  def change
    create_table :eos_knights do |t|
      t.integer :block_num, index: true
      t.string :trx_id, limit: 64, index: true
      t.string :data_md5
      t.datetime :trx_time
      t.string :receiver, limit: 20, index: true
      t.string :sender, limit: 20, index: true
      t.string :code
      t.string :memo
      t.string :symbol
      t.string :status
      t.float :quantity
      t.integer :category, index: true
      t.integer :category_id, index: true
      t.integer :sell_id
      t.string :buyer

      t.timestamps
    end
  end
end