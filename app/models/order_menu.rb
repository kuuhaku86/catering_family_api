class OrderMenu < ApplicationRecord
  self.table_name = "orders_menus"

  belongs_to :order, foreign_key: :order_id
  belongs_to :menu, foreign_key: :menu_id

  validates :quantity, presence: true
  validates :total_price, presence: true
  validates :order, presence: true
  validates :menu, presence: true
end
