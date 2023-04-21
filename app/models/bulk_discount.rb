class BulkDiscount < ApplicationRecord
  validates :percentage_discount, :quantity_threshold, numericality: true, presence: true
  belongs_to :merchant

end