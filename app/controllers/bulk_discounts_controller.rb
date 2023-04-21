class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new]
  before_action :find_bulk_discount, only: [:show]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
  end

  private
  def bulk_discount_params
    params.permit(:quantity_threshold, :percentage_discount)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end