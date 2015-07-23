class CreateBookChapters < ActiveRecord::Migration
  def change
    create_table :book_chapters do |t|
      t.integer :book_id, index:true
      t.integer :book_volume_id, index:true
      t.string :title
      t.text :content
      t.integer :word_count
      t.integer :is_free
      t.integer :types
      t.decimal :price
      t.float :discount
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
