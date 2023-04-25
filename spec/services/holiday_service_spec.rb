require 'rails_helper'

describe HolidayService do
  describe "class methods" do
    describe "holidays" do
      it "returns holiday data" do
        holidays = HolidayService.new.holidays
        holiday_1 = holidays.first

        expect(holidays).to be_a Array
        expect(holiday_1).to be_a Hash

        expect(holiday_1).to have_key :name
        expect(holiday_1[:name]).to be_a(String)

        expect(holiday_1).to have_key :date
        expect(holiday_1[:date]).to be_a(String)
      end
    end
  end
end