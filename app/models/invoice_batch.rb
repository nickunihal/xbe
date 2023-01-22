class InvoiceBatch < ApplicationRecord
	has_many :invoices
	attr_accessor :invoice_ids 

end
