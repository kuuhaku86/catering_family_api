class AlterTableOrdersMenus < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders_menus, :orders_id, :order_id
    rename_column :orders_menus, :menus_id, :menu_id
  end
end
