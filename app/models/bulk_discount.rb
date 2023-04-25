class BulkDiscount < ApplicationRecord
  validates :percentage_discount, numericality: { less_than_or_equal_to: 100}, presence: true
  validates :quantity_threshold, numericality: true, presence: true
  belongs_to :merchant
end