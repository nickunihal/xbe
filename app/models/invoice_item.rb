class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :item_id, presence: true
  # validates :invoice_id, presence: true

  after_update_commit :update_invoices, if: :rate_changed?

  def update_invoices
		InvoiceUpdateOnItemUpdationJob.perform_async(self.item_id)
  end

  def total
  	(self.quantity * self.rate).round(2) rescue ""
  end

end
