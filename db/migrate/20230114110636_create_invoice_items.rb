class CreateInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :item_id
      t.decimal :rate
      t.integer :quantity

      t.timestamps
    end
  end
end
