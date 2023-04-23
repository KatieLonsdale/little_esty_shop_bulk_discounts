namespace :create do
  task :bulk_discount_csv => :environment do
    rows = FactoryBot.create_list(:bulk_discount, 100)

    CSV.open('db/data/bulk_discounts.csv', 'w') do |csv|
      csv << ['id', 'merchant_id', 'percentage_discount', 'quantity_threshold', 'created_at', 'updated_at']

      rows.each do |row|
        merchant_id = Random.new
        array = [row.id, merchant_id.rand(1..100), row.percentage_discount, row.quantity_threshold, row.created_at, row.updated_at]
        csv << array.to_csv.split(',')
      end
    end
  end
end