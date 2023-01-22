class CreateInvoiceBatches < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_batches do |t|
      t.date :batch_date
      t.bigint :total_invoice_amount

      t.timestamps
    end
  end
end
