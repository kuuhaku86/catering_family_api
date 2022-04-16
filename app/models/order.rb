class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_menus

  validates :total_price, presence: true
  validates :status, presence: true
  validates :customer, presence: true
end
