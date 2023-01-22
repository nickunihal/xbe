class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_no
      t.string :full_name
      t.string :phone
      t.string :email
      t.decimal :total_paid_amount
      t.decimal :discount
      t.bigint :invoice_batch_id
      t.timestamps
    end
  end
end
