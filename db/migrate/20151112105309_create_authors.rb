class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.integer :user_id, index:true
      t.integer :book_id, index:true
      t.integer :book_count, default: 0
      t.integer :level, default: 0
      t.boolean :is_identity, default: 0
      t.integer :experience, default: 0
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
