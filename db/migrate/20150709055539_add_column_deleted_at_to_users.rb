class AddColumnDeletedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :integer
  end
end
