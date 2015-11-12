class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.integer :parent_id, index:true
      t.string :name
      t.string  :pinyin, index:true
      t.string :remark
      t.integer :book_count, default: 0
      t.datetime :dalete_at

      t.timestamps null: false
    end
    add_column :books, :classification_id, :integer, index:true
  end
end
