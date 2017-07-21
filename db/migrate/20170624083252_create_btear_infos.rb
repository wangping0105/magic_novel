class CreateBtearInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :btear_infos do |t|
      t.string :currency, index: true
      t.float :value

      t.timestamps
    end
  end
end
