class AddColumnToDownloadUrlChapters < ActiveRecord::Migration[5.0]
  def change
    add_column :book_chapters ,:download_url, :string
  end
end
