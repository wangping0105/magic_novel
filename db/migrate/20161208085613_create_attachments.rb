class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer  :user_id, index: true
      t.integer  :attachmentable_id
      t.string   :attachmentable_type
      t.string   :name
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_updated_at
      t.datetime :deleted_at
      t.text     :note
      t.string   :sub_type
      t.integer  :attachment_position
      t.string   :qiniu_persistent_id, index: true
      t.datetime :updated_at
      t.datetime :created_at

      t.timestamps null: false
    end
    add_index :attachments, [:attachmentable_id, :attachmentable_type]
  end
end
