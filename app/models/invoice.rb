class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue(merchant)
    eligible_items(merchant) + ineligible_items(merchant)
  end

  def eligible_items(merchant)
    InvoiceItem.select("(unit_price, max_discount, quantity")
               .from(invoice_items
               .joins(merchant: :bulk_discounts)
               .group(:id)
               .where("merchants.id = ? and quantity >= bulk_discounts.quantity_threshold", merchant)
               .select("invoice_items.*, 100 - MAX(bulk_discounts.percentage_discount) as max_discount"))
               .sum("(unit_price * max_discount/100) * quantity")
  end

  def ineligible_items(merchant)
    invoice_items.joins(merchant: :bulk_discounts)
                 .where("merchants.id = ? and quantity <  bulk_discounts.quantity_threshold", merchant)
                 .select("invoice_items.*")
                 .sum("invoice_items.unit_price * quantity")
  end
end