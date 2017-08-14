class AddColumnLastestChapterIdToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :lastest_chapter_id, :integer, index: true
  end
end
