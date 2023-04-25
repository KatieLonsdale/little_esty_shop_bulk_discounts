require 'rails_helper'

RSpec.describe Holiday do 
  it "exists" do
    data = {name: "Memorial Day", date: "2023-05-29"}
    holiday = Holiday.new(data)

    expect(holiday).to be_a Holiday
    expect(holiday.name).to eq("Memorial Day")
    expect(holiday.date).to eq("2023-05-29")
  end
end