class CreateBookRelations < ActiveRecord::Migration
  def change
    create_table :book_relations do |t|
      t.integer :book_id, index:true
      t.integer :user_id, index:true
      t.integer :relation_type, default: 0

      t.timestamps null: false
    end
  end
end
