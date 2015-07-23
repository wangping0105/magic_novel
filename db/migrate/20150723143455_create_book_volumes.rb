class CreateBookVolumes < ActiveRecord::Migration
  def change
    create_table :book_volumes do |t|
      t.integer :book_id, index:true
      t.string :title
      t.integer :book_chapter_count
      t.integer :is_free
      t.decimal :price
      t.float :discount
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
