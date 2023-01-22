class InvoiceUpdateOnItemUpdationJob
  include Sidekiq::Worker

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    if invoice.present?
      invoice_batch = InvoiceBatch.find(invoice.invoice_batch_id)
      if invoice_batch.present?
        batch_total_amount = invoice_batch.invoices.sum(&:total_bill_amount)
        invoice_batch.update(total_invoice_amount: batch_total_amount)
      end
    end
  end
end