class BulkDiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_bulk_discount, only: [:show, :destroy, :edit, :update]

  def index
    @bulk_discounts = @merchant.bulk_discounts
    @facade = BulkDiscountFacade.new.next_3_holidays
  end

  def show
  end

  def new
  end

  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params)
    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant.id)     
       flash[:success] = "New Discount Created"
    else
      redirect_to new_merchant_bulk_discount_path(@merchant.id)
      flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant.id)
    flash[:success] = "Deleted Successfully"
  end

  def edit
  end

  def update
    if @bulk_discount.update(update_bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant.id, @bulk_discount.id)
      flash[:success] = "Updated Successfully"
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant.id, @bulk_discount.id)
      flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
    end
  end

  private
  def bulk_discount_params
    params.permit(:quantity_threshold, :percentage_discount, :merchant_id, :bulk_discount)
  end

  def update_bulk_discount_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percentage_discount)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end