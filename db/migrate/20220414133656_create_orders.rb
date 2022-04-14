class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.float :total_price

      t.timestamps
    end

    add_reference :orders, :customer, foreign_key: true
  end
end
