class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string, index: true, comment: '手机', after: :email
  end
end
