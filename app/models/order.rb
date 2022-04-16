class Order < ApplicationRecord
  validates :total_price, presence: true
  validates :status, presence: true
end
