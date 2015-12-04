class AddColumnOperatorToBook < ActiveRecord::Migration
  def change
    add_column :books, :operator_id, :integer, index: true
  end
end
