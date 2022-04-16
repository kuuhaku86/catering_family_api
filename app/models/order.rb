class Order < ApplicationRecord
  belongs_to :customer

  validates :total_price, presence: true
  validates :status, presence: true
  validates :customer, presence: true
end
