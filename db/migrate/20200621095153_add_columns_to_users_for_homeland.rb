class AddColumnsToUsersForHomeland < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_url, :string
  end
end
