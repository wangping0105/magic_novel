class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :source, default: 0, index: true
      t.integer :count, default: 0
      t.string :url

      t.timestamps
    end
  end
end
