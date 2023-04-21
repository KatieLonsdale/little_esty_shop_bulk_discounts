class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]
  before_action :find_bulk_discount, only: [:show]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
  end

  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant.id)      
    else
      redirect_to new_merchant_bulk_discount_path(@merchant.id)
      flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
    end
  end

  private
  def bulk_discount_params
    params.permit(:quantity_threshold, :percentage_discount, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end