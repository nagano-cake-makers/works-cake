class Customer::OrdersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def new
    @order = Order.new
    @deliveries = current_customer.deliveries
  end

  def confirm
    if params[:order].nil?
      flash[:error] = "注文情報が見つかりません"
      redirect_to new_order_path and return
    end

    @cart_items = current_customer.cart_items

    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    customer = current_customer
    payment_method = params[:order][:payment_method].to_i

    # total_paymentに請求額を入れる billingはhelperで定義
    @order.total_payment = billing(@order)

    # my_addressに1が入っていれば（自宅）
    if params[:order][:my_address] == "1"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = full_name(current_customer)

    # my_addressに2が入っていれば（配送先一覧）
    elsif params[:order][:my_address] == "2"
      ship = Delivery.find(params[:order][:delivery_id])
      @order.postal_code = ship.postal_code
      @order.address = ship.address
      @order.name = ship.name

    # my_addressに3が入っていれば(新配送先)
    elsif params[:order][:my_address] == "3"
      @delivery = current_customer.deliveries.create(delivery_params)
      @order.postal_code = @delivery.postal_code
      @order.address = @delivery.address
      @order.name = @delivery.name


    # 有効かどうかの確認
      unless @order.valid? == true
        @deliveries = Delivery.where(customer: current_customer)
        render :new
      end
    end
  end

  def create
    @order = current_customer.orders.new(order_params)
    if @order.save!
        @cart_items = current_customer.cart_items
        @cart_items.each do |cart_item|
          @order_detail = OrderDetail.new
          @order_detail.item_id = cart_item.item_id
          @order_detail.order_id = @order.id
          @order_detail.count = cart_item.count
          @order_detail.price = cart_item.item.price * cart_item.count
          if @order_detail.save
            @cart_items.destroy_all
          else
            # 注文詳細の保存に失敗したときのエラーハンドリング
            flash[:error] = "注文詳細を保存できませんでした"
            render :new and return
          end
        end
        redirect_to thanks_orders_path

    else
      # 注文の保存に失敗したときのエラーハンドリング
      flash[:error] = "注文を保存できませんでした"
      render :new and return
    end
  end


  def thanks
  end

  private
  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :payment_method, :total_payment)
  end

  def delivery_params
    params.require(:delivery).permit(:postal_code, :address, :name)
  end
end
