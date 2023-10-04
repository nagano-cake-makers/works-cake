class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item = Item.new
  end

  def index
    @items = Item.page(params[:page]).per(10)
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "商品の新規登録が完了しました。"
      redirect_to admin_item_path(@item)
    else
      flash[:alert] = "商品の新規登録内容に不備があります。"
      render 'new'
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :image, :introduction, :price, :genre_id, :is_active)
  end
end
