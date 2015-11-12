class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :remark
      t.string  :pinyin, index:true
      t.integer :book_count, default: 0
      t.datetime :deleted_at

      t.timestamps null: false
    end

    create_table :book_tag_relations do |t|
      t.integer :book_id, index:true
      t.integer :tag_id, index:true
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
