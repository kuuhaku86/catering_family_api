class AlterOrdersMenusTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :order_menus, :orders_menus

    add_reference :orders_menus, :orders, foreign_key: true
    add_reference :orders_menus, :menus, foreign_key: true

    add_index :orders_menus, [:order_id, :menu_id], unique: true
  end
end
