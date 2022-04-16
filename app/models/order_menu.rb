class OrderMenu < ApplicationRecord
  self.table_name = "orders_menus"

  validates :quantity, presence: true
  validates :total_price, presence: true
end
