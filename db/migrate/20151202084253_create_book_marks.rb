class CreateBookMarks < ActiveRecord::Migration
  def change
    create_table :book_marks do |t|
      t.integer :user_id, index: true
      t.integer :book_id, index: true
      t.integer :book_chapter_id, index: true

      t.timestamps null: false
    end
  end
end
