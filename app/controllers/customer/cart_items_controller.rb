class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = CartItem.where(customer:current_customer)
  end

  def create
    @cart_item = CartItem.find_by(customer_id: current_customer.id, item_id: params[:cart_item][:item_id])
    if @cart_item
      @cart_item.count += params[:cart_item][:count].to_i
      @cart_item.save
      flash[:success] =  "カートに存在済みのアイテムです"
      redirect_to cart_items_path
    else
      @cart_item = CartItem.new(cart_items_params)
      @cart_item.customer_id = current_customer.id
      if @cart_item.save
        flash[:success] = "カートに追加しました"
        redirect_to cart_items_path
      else
        flash[:danger] = "予期せぬエラーが発生しました: " + @cart_item.errors.full_messages.join(", ")
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_items_params)
      flash[:success] = "個数を変更しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "正しい個数を入力してください"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash[:success] = "選択頂いたカートを空にしました"
    redirect_back(fallback_location: root_path)
  end

  def all_destroy
    CartItem.where(customer_id: current_customer.id).destroy_all
    flash[:success] = "カートの中身を空にしました"
    redirect_back(fallback_location: root_path)
  end

  private
  def cart_items_params
    params.require(:cart_item).permit(:item_id, :count)
  end
end
