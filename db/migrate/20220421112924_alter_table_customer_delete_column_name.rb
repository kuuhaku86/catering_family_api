class AlterTableCustomerDeleteColumnName < ActiveRecord::Migration[7.0]
  def change
    remove_column :customers, :name
  end
end
