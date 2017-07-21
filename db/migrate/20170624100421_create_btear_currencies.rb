class CreateBtearCurrencies < ActiveRecord::Migration[5.0]
  def change
    create_table :btear_currencies do |t|
      t.string :name
      t.float :min
      t.float :max
      t.float :current
      t.float :today_first
      t.date  :today_first_date

      t.timestamps
    end
  end
end
