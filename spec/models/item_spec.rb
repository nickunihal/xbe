require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { Item.create(name: "Product1", mrp: 499, category: "Stationary") }
  

  it "is valid with valid attributes" do
    expect(item).to be_valid
  end
  it "is not valid without a Name" do
    item.name = nil
    expect(item).to_not be_valid
  end
  it "is not valid without mrp" do
    item.mrp = nil
    expect(item).to_not be_valid
  end
  it "is not valid without category" do
    item.category = nil
    expect(item).to_not be_valid
  end

end
