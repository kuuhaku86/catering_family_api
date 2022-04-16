class OrderMenu < ApplicationRecord
  self.table_name = "orders_menus"

  belongs_to :order, foreign_key: :order_id

  validates :quantity, presence: true
  validates :total_price, presence: true
  validates :order, presence: true
end
