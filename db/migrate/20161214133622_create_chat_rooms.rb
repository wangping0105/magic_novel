class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.string :no, index: true
      t.string :name
      t.integer :book_id, index: true

      t.timestamps null: false
    end
  end
end
