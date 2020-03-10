class AddColumnSourceToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :source, :string, default: :magicbooks, index: true
  end
end
