require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  let(:item) { Item.create(name: "Product1", mrp: 499, category: "Stationary") }
  let(:invoice) { Invoice.create(full_name: "Nihal", phone: "8129000000", email: "nihal@sample.com" ,invoice_no: "XBE001") }
	let(:invoice_item) { InvoiceItem.create(invoice_id: invoice.id, item_id: item.id, rate: 100, quantity: 2) }
  
  it "is valid with valid attributes" do
    expect(invoice_item).to be_valid
  end
  it "is not valid without item id" do
    invoice_item.item_id = nil
    expect(invoice_item).to_not be_valid
  end

end
