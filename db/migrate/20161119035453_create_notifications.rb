class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :subject_id
      t.string :subject_type
      t.integer :notify_type
      t.integer :status
      t.string :path
      t.text :body_html
      t.integer :category
      t.text :extras
      t.integer :receive_platform

      t.timestamps null: false
    end
  end
end
