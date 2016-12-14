class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :chat_room_id, index: true
      t.text :content
      t.integer :user_id, index: true
      t.integer :status, default: 0, index: true

      t.timestamps null: false
    end
  end
end
