require 'rails_helper'

RSpec.describe Invoice, type: :model do
  let(:invoice_batch) { InvoiceBatch.create(batch_date: Date.today, total_invoice_amount: 499) }
  let(:invoice) { Invoice.create(full_name: "Nihal", phone: "8129000000", email: "nihal@sample.com" ,invoice_no: "XBE001",invoice_batch_id: invoice_batch.id) }
  
  it "is valid with valid attributes" do
    expect(invoice).to be_valid
  end
  it "is not valid without a Name" do
    invoice.full_name = nil
    expect(invoice).to_not be_valid
  end
  it "is not valid without phone number" do
    invoice.phone = nil
    expect(invoice).to_not be_valid
  end
  it "is not valid without email" do
    invoice.email = nil
    expect(invoice).to_not be_valid
  end
  it "is valid without batch id also" do
    invoice.invoice_batch_id = nil
    expect(invoice).to be_valid
  end

end
