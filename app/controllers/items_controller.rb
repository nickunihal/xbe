class ItemsController < ApplicationController
  def index
    @data = Item.all.sort_by(&:id)
  end

  def new
    @item = Item.new    
  end

  def create
  	@item = Item.create(params.require(:item).permit(:name, :category, :mrp))
    if @item
      flash[:success] = "Item successfully created!"
      redirect_to items_index_path
    else
      flash.now[:error] = "Item creation failed"
      render :edit
    end  	
  end

  def edit
		if request.get?
			@item = Item.find_by_id params[:id]
		else
			return "OK"	
		end
  end

  def update
    @item = Item.find(params[:item][:id])  	
    if @item.update(params.require(:item).permit(:name, :category, :mrp))
      flash[:success] = "Item successfully updated!"
      redirect_to items_index_path
    else
      flash.now[:error] = "Item update failed"
      render :edit
    end
  end

end
