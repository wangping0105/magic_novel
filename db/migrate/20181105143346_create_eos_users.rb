class CreateEosUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :eos_users do |t|
      t.string :account

      t.timestamps
    end
  end
end
