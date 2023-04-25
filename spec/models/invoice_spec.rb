require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    describe "total_revenue" do
      it "returns total revenue of the invoice" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        expect(@invoice_1.total_revenue).to eq(100)
      end
    end
    
    describe "all_discounted_revenue" do
      it "returns the total revenue after discounts for all merchants on an invoice" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'another merchant')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "hoodie", description: "warm", unit_price: 20, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 10, unit_price: 20, status: 1)
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 4, unit_price: 20, status: 1)
        @ii_5 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 11, unit_price: 20, status: 1)
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)
        @bulk_discount2 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)

        expect(@invoice_1.all_discounted_revenue).to eq(205)
        expect(@invoice_2.all_discounted_revenue).to eq(245)
      end
    end

    describe "all_eligible_items" do
      it "returns the total revenue from items that are eligible for a discount" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'another merchant')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "hoodie", description: "warm", unit_price: 20, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 10, unit_price: 20, status: 1)
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)
        @bulk_discount2 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)

        expect(@invoice_1.all_eligible_items).to eq(195)
      end
    end

    describe "all_ineligible_items" do
      it "returns the total revenue from items that are eligible for a discount" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'another merchant')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "hoodie", description: "warm", unit_price: 20, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 10, unit_price: 20, status: 1)
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)
        @bulk_discount2 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)

        expect(@invoice_1.all_ineligible_items).to eq(10)
      end
    end

    describe "total_discounted_revenue" do
      before(:each) do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'another merchant')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "hoodie", description: "warm", unit_price: 20, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 10, unit_price: 20, status: 1)
      end
      it "returns total revenue from invoice after discounts for given merchant" do
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)
        @bulk_discount2 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)
        expect(@invoice_1.total_discounted_revenue(@merchant1)).to eq(55)
        expect(@invoice_1.total_discounted_revenue(@merchant2)).to eq(150)
      end
      it "considers each item's quantity when applying a discount, not combined item quantities" do
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 10, merchant_id: @merchant1.id)
        expect(@invoice_1.total_discounted_revenue(@merchant1)).to eq(100)
      end
      it "applies the biggest discount if item quantity exceeds threshold for multiple discounts" do
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 25, quantity_threshold: 10, merchant_id: @merchant2.id)
        @bulk_discount2 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant2.id)
        expect(@invoice_1.total_discounted_revenue(@merchant2)).to eq(100)
      end
      it "returns total if there are no discounts" do
        expect(@invoice_1.total_discounted_revenue(@merchant1)).to eq(300)
        expect(@invoice_1.total_discounted_revenue(@merchant2)).to eq(300)
        # using wrong expects based on what last person's total_revenue method would return
      end
    end

    describe "eligible_items" do
      it "returns the total revenue from items that are eligible for a discount" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 10, status: 1)
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)

        expect(@invoice_1.eligible_items(@merchant1)).to eq(45)
      end
    end

    describe "ineligible_items" do
      it "returns the total revenue from items that are eligible for a discount" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_2 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 4, unit_price: 10, status: 1)
        @bulk_discount1 = BulkDiscount.create!(percentage_discount: 50, quantity_threshold: 5, merchant_id: @merchant1.id)

        expect(@invoice_1.ineligible_items(@merchant1)).to eq(40)
      end
    end

  end
end
