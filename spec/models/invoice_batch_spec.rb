require 'rails_helper'

RSpec.describe InvoiceBatch, type: :model do
  let(:item) { Item.create(name: "Product1", mrp: 499, category: "Stationary") }
  let(:invoice) { Invoice.create(full_name: "Nihal", phone: "8129000000", email: "nihal@sample.com" ,invoice_no: "XBE001") }
	let(:invoice_item) { InvoiceItem.create(invoice_id: invoice.id, item_id: item.id, rate: 100, quantity: 2) }
	let(:batch_amount) { invoice.total_bill_amount}
	let(:invoice_batch) { InvoiceBatch.create( batch_date: Date.today, total_invoice_amount: batch_amount ) }

	context "Invoice Batch" do 
 		before do
	  	invoice.invoice_batch_id = invoice_batch.id
  	  invoice.save!
	  end

	  it "is valid with valid attributes" do
	    expect(invoice_batch).to be_valid
	  end

	end  
end
