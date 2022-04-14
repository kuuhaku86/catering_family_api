class CreateOrderMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :order_menus do |t|
      t.integer :quantity
      t.float :total_price

      t.timestamps
    end
  end
end
