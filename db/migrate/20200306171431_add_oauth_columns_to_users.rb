class AddOauthColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string, index: true, default: :magicbook
    add_column :users, :provider_uid, :string
    add_column :users, :avatar_url, :string

    add_index :users, :email
    add_index :users, :phone
  end
end
