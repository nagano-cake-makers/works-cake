class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!
  def update
    @order_detail = OrderDetail.find_by(id: params[:id])
    if @order_detail.nil?
      flash[:alert] = "OrderDetail with id=#{params[:id]} not found."
      redirect_to request.referer and return
    end

    @order = @order_detail.order
    if @order_detail.update(order_detail_params)
      Rails.logger.info "After update: #{@order_detail.making_status}"
      # 制作ステータスを「製作中(2)」→注文ステータスを「製作中(2)」
      if @order_detail.making_status == "製作中"
        unless @order.update(status: 2)
          Rails.logger.error @order.error.full_messages.join(", ")
        end
        flash[:notice] = "制作ステータスの更新しました。"
      # 注文個数と制作完了になっている個数が同じならば
      elsif @order.order_details.count == @order.order_details.where(making_status: 3).count
        unless @order.update(status: 4)
          Rails.logger.error @order.error.full_messages.join(", ")
        end
        flash[:notice] = "制作ステータスの更新しました。"
      # 制作ステータスが「製作完了」→注文ステータスを「発送準備中」
      elsif @order_detail.making_status == "製作完了"
        unless @order.update(status: 3) # status: 4 を「発送準備中」に対応させてください。
          Rails.logger.error @order.error.full_messages.join(", ")
        end
        flash[:notice] = "制作ステータスの更新しました。"

      else
        flash[:alert] = "制作ステータスの更新に失敗しました。"
      end
      redirect_to request.referer
    end
  end
  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status, :count)
  end
end

