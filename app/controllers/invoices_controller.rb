class InvoicesController < ApplicationController
  def index
  	@data = Invoice.all
  end

  def show
  	@invoice = Invoice.find params[:id]
  	@invoice_items = InvoiceItem.where(invoice_id: @invoice.id)
  end

  def new
    @invoice = Invoice.new    
    invoice_items = @invoice.invoice_items.build
   end

  def create
  	@invoice = Invoice.create(params.require(:invoice).permit(:id,:invoice_no, :full_name, :phone, :email, :total_paid_amount, :discount,invoice_items_attributes: [:item_id,:invoice_id,:rate,:quantity]))
    if @invoice
      flash[:success] = "Invoice successfully created!"
      redirect_to invoices_index_path
    else
      flash.now[:error] = "Invoice creation failed"
      render :edit
    end  	
  end

  def edit
		if request.get?
			@invoice = Invoice.find_by_id params[:id]
		else
			return "OK"	
		end
  end

  def update
    @invoice = Invoice.find(params[:invoice][:id])  	

    if @invoice.update(params.require(:invoice).permit(:invoice_no, :full_name, :phone, :email, :total_paid_amount, :discount, :invoice_batch_id))
      flash[:success] = "Invoice successfully updated!"
      redirect_to invoices_index_path
    else
      flash.now[:error] = "Invoice update failed"
      render :edit
    end
  end

  def invoice_batches
    @data = InvoiceBatch.all    
  end

  def invoice_batch_new
    @invoice_batch = InvoiceBatch.new
  end

  def invoice_batch_create
    @invoice_batch = InvoiceBatch.create(params.require(:invoice_batch).permit(:id,:batch_date, :total_invoice_amount,:invoice_ids))
    if @invoice_batch
      Invoice.where(id: params[:invoice_batch][:invoice_ids]).update(invoice_batch_id: @invoice_batch.id)
      flash[:success] = "Invoice successfully created!"
      redirect_to invoices_invoice_batches_path
    else
      flash.now[:error] = "Invoice creation failed"
      render :edit
    end   
  end

end
