require 'rails_helper'

RSpec.describe 'Bulk discounts new page' do
  before(:each) do
    @merchant = create(:merchant)
  end

  describe "As a merchant, when I visit the bulk discounts new page" do
    it "I see a form to add a new bulk discount" do
      visit new_merchant_bulk_discount_path(@merchant.id)
      within("#new_bulk_discount") do
        fill_in "Percentage Discount", with: 55
        fill_in "Quantity Threshold", with: 101
        click_button "Submit"
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))

      within("#all-discounts") do
        expect(page).to have_content("55% off 101 or more")
      end
      expect(page).to have_content("New Discount Created")
    end

    it "returns an error if a field is blank" do
      visit new_merchant_bulk_discount_path(@merchant.id)
      within("#new_bulk_discount") do
        fill_in "Quantity Threshold", with: 101
        click_button "Submit"
      end

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
      expect(page).to have_content("Percentage discount can't be blank")
    end

    it "returns an error if wrong data type is input" do
      visit new_merchant_bulk_discount_path(@merchant.id)
      within("#new_bulk_discount") do
        fill_in "Percentage Discount", with: 55
        fill_in "Quantity Threshold", with: "Katie"
        click_button "Submit"
      end

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
      expect(page).to have_content("Quantity threshold is not a number")
    end
  end
end