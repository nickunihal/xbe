class Invoice < ApplicationRecord
  has_many :invoice_items, :dependent => :destroy
  has_many :items, :through => :invoice_items
  belongs_to :invoice_batch, optional: true

  accepts_nested_attributes_for :invoice_items , allow_destroy: true, reject_if: :all_blank

  validates :full_name, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :invoice_no, presence: true


  def total_bill_amount
		amount = 0
		self.invoice_items.each do |invoice_item|
			amount += (invoice_item.quantity.to_i * invoice_item.rate.to_i)
		end  	
		return amount
  end

end
