class CreateRequestLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :btear_currencies, :top, :integer, index: true

    create_table :request_logs do |t|
      t.string :ip, index: true
      t.integer :count, default: 0
      t.string :country
      t.string :address
      t.integer :user_id, index: true
      t.integer :last_chapter_id, index: true

      t.timestamps
    end
  end
end
