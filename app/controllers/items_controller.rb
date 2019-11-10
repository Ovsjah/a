class ItemsController < ApplicationController
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: {errors: @item.errors.full_messages}
    end
  end

  private

  def item_params
    params.permit(:name, :cost)
  end
end
