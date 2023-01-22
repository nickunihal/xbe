class InvoiceLineItemSyncJob
  include Sidekiq::Worker

  def perform(args)
  	updated_items = InvoiceItem.where(updated_at: [Date.yesterday.beginning_of_day..Date.today.end_of_day]).pluck(:id,:rate).to_h

    invoices_items_to_update = InvoiceItem.where(item_id: updated_items.keys)

    invoices_items_to_update.each do |invoice_item|
    	next if invoice_item.rate == updated_items[invoice_item.item_id]
    	invoice_item.update(rate: updated_items[invoice_item.item_id])
    end

  	puts "Done"
  end
end