class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_menus

  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :customer, presence: true
end
