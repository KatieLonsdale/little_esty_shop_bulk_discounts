require 'rails_helper'

RSpec.describe BulkDiscount do
  describe "validations" do
    it { should validate_presence_of :percentage_discount}
    it { should validate_numericality_of(:percentage_discount).is_less_than_or_equal_to(100)}
    it { should validate_presence_of :quantity_threshold}
    it { should validate_numericality_of :quantity_threshold}
  end

  describe "relationships" do
    it { should belong_to :merchant}
  end
end