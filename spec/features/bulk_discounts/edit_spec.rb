require 'rails_helper'

RSpec.describe "Bulk discount edit page" do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discounts = create_list(:bulk_discount, 5, merchant_id: @merchant.id)
    @bd_1 = @bulk_discounts.first
  end
  describe "As a merchant, when I visit the bulk discount edit page" do
    it "has a form to edit the discount with current attributes pre-poulated" do
      visit edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id)

      within("#edit-bulk-discount") do
        expect(page).to have_field("Percentage Discount", with: "#{@bd_1.percentage_discount}")
        expect(page).to have_field("Quantity Threshold", with: "#{@bd_1.quantity_threshold}")
      end
    end
    it "when I change any/all of the info it brings me to the bd show page where it has been updated" do
      visit edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id)
      within("#edit-bulk-discount") do
        fill_in "Percentage Discount", with: 55
        fill_in "Quantity Threshold", with: 101
        click_button "Submit"
      end

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bd_1.id))

      within("#bd-info") do
        expect(page).to have_content("55% off 101 or more")
      end
    end
    it "returns an error if any fields are left blank" do
      visit edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id)
      within("#edit-bulk-discount") do
        fill_in "Percentage Discount", with: 55
        fill_in "Quantity Threshold", with: ""
        click_button "Submit"
      end

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id))
      expect(page).to have_content("Quantity threshold can't be blank")
    end
    it "returns an error if any input is invalid" do
      visit edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id)
      within("#edit-bulk-discount") do
        fill_in "Percentage Discount", with: "String"
        fill_in "Quantity Threshold", with: 101
        click_button "Submit"
      end

      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id))
      expect(page).to have_content("Percentage discount is not a number")
    end
    it "returns an error if percentage is over 100" do
      visit edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id)
      within("#edit-bulk-discount") do
        fill_in "Percentage Discount", with: 101
        fill_in "Quantity Threshold", with: 50
        click_button "Submit"
      end
 
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bd_1.id))
      expect(page).to have_content("Percentage discount must be less than or equal to 100")
    end
  end
end