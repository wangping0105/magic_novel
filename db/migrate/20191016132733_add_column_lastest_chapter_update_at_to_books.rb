class AddColumnLastestChapterUpdateAtToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :chapter_updated_date, :date, index: true
  end
end
