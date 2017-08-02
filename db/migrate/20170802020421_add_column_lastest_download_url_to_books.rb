class AddColumnLastestDownloadUrlToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :lastest_download_url, :string
  end
end
