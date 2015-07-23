class CreateBookTypes < ActiveRecord::Migration
  def change
    create_table :book_types do |t|
      t.string :name
      t.integer :book_count
      t.string :remarks
      t.string  :pinyin
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
