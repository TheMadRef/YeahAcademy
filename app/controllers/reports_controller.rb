class ReportsController < ApplicationController

  before_filter :require_id, :only => [ :payment_receipt ]

  def payment_receipt
    @order = Order.find(params[:id])
    @line_items = @order.line_items.find(:all)
  end
end
