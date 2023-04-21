require 'rails_helper'

RSpec.describe "Bulk discounts show page" do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discounts = create_list(:bulk_discount, 5, merchant_id: @merchant.id)
    @bd_1 = @bulk_discounts.first
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

  it "has a link to edit the bulk discount" do
    visit merchant_bulk_discount_path(@merchant.id, @bd_1.id)
    within("#edit") do
      expect(page).to have_link("Edit")
      click_link("Edit")
    end

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id))
  end
end


# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated