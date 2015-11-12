class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :pinyin
      t.integer :author_id , index:true
      t.integer :book_type, index:true
      t.text :introduction
      t.string :remarks
      t.integer :status, default:0
      t.decimal :total_price
      t.float :discount
      t.integer :words
      t.integer :click_count, default:0
      t.integer :recommend_count, default:0
      t.integer :collection_count, default:0
      t.integer :book_volume_count, default:0
      t.integer :book_chapter_count, default:0
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
