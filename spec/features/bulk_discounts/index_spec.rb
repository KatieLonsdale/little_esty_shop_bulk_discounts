require 'rails_helper'

RSpec.describe "merchant bulk discounts index page" do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discounts = create_list(:bulk_discount, 5, merchant_id: @merchant.id)
    @bd_1 = @bulk_discounts.first
    @bd_2 = @bulk_discounts[1]
  end
  
  describe "As a merchant, when I visit my bulk discounts index page" do
    it "lists all of my bulk discounts - their discount and their qty threshold" do
      visit merchant_bulk_discounts_path(@merchant.id)
      @bulk_discounts.each do |bd|
        within("#discount-#{bd.id}") do
          expect(page).to have_content("#{bd.percentage_discount}% off #{bd.quantity_threshold} or more")
        end
      end
    end
    
    it "links each bulk discount to its show page" do
      visit merchant_bulk_discounts_path(@merchant.id)
      within("#discount-#{@bd_1.id}") do
        click_link("View")
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bd_1.id))
    end
    
    it "has a link to create a new discount" do
      visit merchant_bulk_discounts_path(@merchant.id)
      within("#create-new") do
        click_link("Create New Discount")
      end
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
    end
    
    it "has a link to delete each discount" do
      visit merchant_bulk_discounts_path(@merchant.id)
      within("#discount-#{@bd_1.id}") do
        expect(page).to have_link("Delete")
        click_link("Delete")
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))

      within("#all-discounts") do
        expect(page).to have_no_content("#{@bd_1.percentage_discount}% off #{@bd_1.quantity_threshold} or more")
        expect(page).to have_content("#{@bd_2.percentage_discount}% off #{@bd_2.quantity_threshold} or more")
      end
    end
  end
end

# As a merchant
# When I visit my bulk discounts index
# Then next to each bulk discount I see a link to delete it
# When I click this link
# Then I am redirected back to the bulk discounts index page
# And I no longer see the discount listed