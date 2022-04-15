class Menu < ApplicationRecord
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :description, presence: true, length: { maximum: 150 }
  validates :categories, presence: true
end
