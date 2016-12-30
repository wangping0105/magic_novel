class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.string :uid
      t.string :device_token
      t.string :client_id
      t.integer :platform
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
