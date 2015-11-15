class CreateBookVolumes < ActiveRecord::Migration
  def change
    create_table :book_volumes do |t|
      t.integer :book_id, index:true
      t.string :title
      t.integer :book_chapters_count, default: 0
      t.integer :is_free
      t.decimal :price
      t.float :discount
      t.integer :next_volume_id
      t.integer :prev_volume_id
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
