class Customer::DeliveriesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @deliveries = current_customer.deliveries
  	@delivery = Delivery.new
  end

  def create
    @delivery = Delivery.new(address_params)
	  @delivery.customer_id = current_customer.id
    @deliveries = current_customer.deliveries
  	  @delivery.save
  	  flash.now[:notice] = "新規配送先を登録しました"
  	  redirect_to deliveries_path
  end

  def destroy
    @delivery = Delivery.find(params[:id])
	  @delivery.destroy
    @deliveries = current_customer.delivery
    flash.now[:alert] = "配送先を削除しました"
	  redirect_to deliveries_path
  end

  def edit
    @delivery = Delivery.find(params[:id])
  end

  def update
    @delibery = Delivery.find(params[:id])
    if @delivery.update(delivery_params)
      flash[:success] = "配送先を変更しました"
      redirect_to deliberies_path
    else
      render "edit"
    end
  end

  private

  def delibery_params
  	params.require(:address).permit(:postal_code, :address, :name)
  end

end
