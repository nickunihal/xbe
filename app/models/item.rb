class Item < ApplicationRecord

  validates :name, presence: true
  validates :mrp, presence: true
  validates :category, presence: true

end
