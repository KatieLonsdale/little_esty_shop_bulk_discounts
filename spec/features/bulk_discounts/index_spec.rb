require 'rails_helper'

RSpec.describe "merchant bulk discounts index page" do
  before(:each) do
    @bulk_discounts = create_list(:bulk_discount, 5)
    @bd_1 = @bulk_discounts.first
  end
  
  describe "As a merchant, when I visit my bulk discounts index page" do
    it "lists all of my bulk discounts - their discount and their qty threshold" do
      @bulk_discounts.each do |bd|
        visit merchant_bulk_discounts_path(bd.merchant_id)
        within("#discount-#{bd.id}") do
          expect(page).to have_content("#{bd.percentage_discount}% off #{bd.quantity_threshold} or more")
        end
      end
    end
    it "links each bulk discount to its show page" do
      visit merchant_bulk_discounts_path(@bd_1.merchant_id)
      within("#discount-#{@bd_1.id}") do
        click_link("View")
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@bd_1.merchant_id, @bd_1.id))
    end
    it "has a link to create a new discount" do
      visit merchant_bulk_discounts_path(@bd_1.merchant_id)
      within("#create-new") do
        click_link("Create New Discount")
      end
      expect(current_path).to eq(new_merchant_bulk_discount_path(@bd_1.merchant_id))
    end
  end
end


# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed