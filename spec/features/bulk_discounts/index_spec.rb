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
        expect(page).to have_button("View")
        click_button("View")
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
        expect(page).to have_button("Delete")
        click_button("Delete")
      end

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant.id))

      within("#all-discounts") do
        expect(page).to have_no_content("#{@bd_1.percentage_discount}% off #{@bd_1.quantity_threshold} or more")
        expect(page).to have_content("#{@bd_2.percentage_discount}% off #{@bd_2.quantity_threshold} or more")
      end
      expect(page).to have_content("Deleted Successfully")
    end

    it "has an upcoming holidays section with the next 3 upcoming holidays' name and date" do
      visit merchant_bulk_discounts_path(@merchant.id)

      within("#holidays") do
        expect(page).to have_content("Upcoming Holidays")
        holidays = BulkDiscountFacade.new.next_3_holidays
        holidays.each do |holiday|
          expect(page).to have_content(holiday.name)
          expect(page).to have_content(holiday.date)
        end
      end
    end
  end
end