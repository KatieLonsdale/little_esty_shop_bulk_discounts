require 'rails_helper'

RSpec.describe "Bulk discounts show page" do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discounts = create_list(:bulk_discount, 5, merchant_id: @merchant.id)
  end
  describe "As a merchant, when I visit my bulk discount show page" do
    it "shows me the bulk discount's quantity threshold and percentage discount" do
      @bulk_discounts.each do |bd|
        visit merchant_bulk_discount_path(@merchant.id, bd.id)
        within("#bd-info") do
          expect(page).to have_content("#{bd.percentage_discount}% off #{bd.quantity_threshold} or more")
        end
      end
    end
  end
end