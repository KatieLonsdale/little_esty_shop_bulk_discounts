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

  def discounted_revenue
    InvoiceItem.from(
      invoice_items.joins(merchant: :bulk_discounts)
      .select("invoice_items.*, MAX((bulk_discounts.percentage_discount * invoice_items.quantity) * invoice_items.unit_price / 100 ) AS max_discount")
      .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
      .group(:id))
    .sum("max_discount")
  end

  def merchant_discounted_revenue(merchant)
    InvoiceItem.from(
      invoice_items.joins(merchant: :bulk_discounts)
      .select("invoice_items.*, MAX((bulk_discounts.percentage_discount * invoice_items.quantity) * invoice_items.unit_price / 100 ) AS max_discount")
      .where("invoice_items.quantity >= bulk_discounts.quantity_threshold AND bulk_discounts.merchant_id = ?", merchant )
      .group(:id))
      .sum("max_discount")
  end

  # def all_discounted_revenue
  #   if BulkDiscount.all.empty?
  #     total_revenue
  #   else
  #     all_eligible_items + all_ineligible_items
  #   end
  # end

  # def all_eligible_items
  #   InvoiceItem.select("(unit_price, max_discount, quantity")
  #              .from(invoice_items
  #              .joins(merchant: :bulk_discounts)
  #              .group(:id)
  #              .where("quantity >= bulk_discounts.quantity_threshold")
  #              .select("invoice_items.*, 100 - MAX(bulk_discounts.percentage_discount) as max_discount"))
  #              .sum("(unit_price * max_discount/100) * quantity")
  # end

  # def all_ineligible_items
    # invoice_items.joins(merchant: :bulk_discounts)
    #              .where("quantity < bulk_discounts.quantity_threshold")
    #              .select("invoice_items.*")
    #              .distinct
    #              .sum("invoice_items.unit_price * quantity")
  # end

  # def total_discounted_revenue(merchant)
  #   if merchant.bulk_discounts.empty?
  #     total_revenue
  #   else
  #     eligible_items(merchant) + ineligible_items(merchant)
  #   end
  # end

  # def eligible_items(merchant)
  #   InvoiceItem.select("(unit_price, max_discount, quantity").distinct.from(invoice_items
  #              .joins(merchant: :bulk_discounts)
  #              .group(:id)
  #              .where("merchants.id = ? and quantity >= bulk_discounts.quantity_threshold", merchant)
  #              .select("invoice_items.*, 100 - MAX(bulk_discounts.percentage_discount) as max_discount"))
  #              .sum("(unit_price * max_discount/100) * quantity")
  # end

  # def ineligible_items(merchant)
  #   invoice_items.joins(merchant: :bulk_discounts)
  #                .where("merchants.id = ? and quantity < bulk_discounts.quantity_threshold", merchant)
  #                .select("invoice_items.*")
  #                .sum("invoice_items.unit_price * quantity")
  # end
end