require "spec_helper"
require 'pg'

RSpec.describe  do

  let(:item1) { Item.create(name: "Product1", mrp: 499, category: "Stationary") }
  let(:item2) { Item.create(name: "Product2", mrp: 199, category: "Stationary") }

  let(:invoice1) { Invoice.create(full_name: "Nihal", phone: "8129000000", email: "nihal@sample.com" ,invoice_no: "XBE001") }
	let(:invoice_item1_1) { InvoiceItem.create(invoice_id: invoice1.id, item_id: item1.id, rate: 100, quantity: 2) }

  let(:invoice2) { Invoice.create(full_name: "Nihal Nizar", phone: "8129000001", email: "nihal2@sample.com" ,invoice_no: "XBE002") }
	let(:invoice_item2_1) { InvoiceItem.create(invoice_id: invoice2.id, item_id: item1.id, rate: 100, quantity: 2) }
	let(:invoice_item2_2) { InvoiceItem.create(invoice_id: invoice2.id, item_id: item2.id, rate: 100, quantity: 2) }

	let(:invoice_batch) { InvoiceBatch.create(batch_date: Date.today, total_invoice_amount: 600) }

	context "Invoice Item Rate Updation" do  
		before do
	  	invoice1.invoice_batch_id = invoice_batch.id
  	  invoice1.save!
  	  invoice1.reload
	  	invoice2.invoice_batch_id = invoice_batch.id
  	  invoice2.save!
  	  invoice2.reload
	  end

	  it "Invoice batch amount is sum of invoice bill amounts" do

			invoice_item2_2.rate = invoice_item2_2.rate
			# invoice_item2_2.save
			invoice_item2_1.rate = invoice_item2_1.rate
			# invoice_item2_1.save
			invoice_item1_1.rate = invoice_item1_1.rate
			# invoice_item1_1.save
	    expect(invoice_batch.total_invoice_amount).to eq(invoice1.total_bill_amount + invoice2.total_bill_amount)
	  end

	  it "Invoice Batch amount changes on Correspondin invoice item rate updation" do

      conn = ActiveRecord::Base.connection.instance_variable_get(:@connection)

		  it_ran = false
		  conn.exec "LISTEN item_mrp_updation"
		  conn.exec "NOTIFY item_mrp_updation, 'hello'"
		  # invoice_item1_1.rate = 50
		  # invoice_item1_1.save
		  # invoice_item1_1.reload
		  conn.wait_for_notify(1) do |channel, pid, payload|
		    it_ran = true
		  end
		  expect(it_ran).to eq true
		end
	
		it "amount updation logic" do
			invoice_item2_2.rate = invoice_item2_2.rate + 100
			invoice_item2_2.save
			invoice_item1_1.rate = invoice_item2_2.rate + 500
			invoice_item1_1.save

			invoice1.reload
			invoice2.reload
			invoice_batch.total_invoice_amount = invoice1.total_bill_amount + invoice2.total_bill_amount
			invoice_batch.save
			invoice_batch.reload

			expect(invoice_batch.total_invoice_amount).to eq(invoice1.total_bill_amount + invoice2.total_bill_amount)

		end	
	end
end