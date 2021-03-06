class Order < ApplicationRecord
  STATUS = {
    :new => "NEW",
    :paid => "PAID",
    :canceled => "CANCELED"
  }.freeze

  belongs_to :customer
  has_many :order_menus

  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, :inclusion=> { :in => [STATUS[:new], STATUS[:paid], STATUS[:canceled]] }
  validates :customer, presence: true

  def self.cancel_new_orders
    where(status: STATUS[:new]).update_all(status: STATUS[:canceled])
  end
end
