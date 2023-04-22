FactoryBot.define do
  factory :customer do
    sequence(:id)
    first_name {Faker::Name.first_name}
    last_name {Faker::Dessert.variety}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end

  factory :invoice do
    sequence(:id)
    status {[0,1,2].sample}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    association :customer
  end

  factory :merchant do
    sequence(:id)
    name {Faker::Space.galaxy}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end

  factory :item do
    sequence(:id)
    name {Faker::Coffee.variety}
    description {Faker::Hipster.sentence}
    unit_price {Faker::Number.decimal(l_digits: 2)}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    association :merchant
  end

  factory :transaction do
    sequence(:id)
    result {[0,1].sample}
    credit_card_number {Faker::Finance.credit_card}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    association :invoice
  end

  factory :invoice_item do
    sequence(:id)
    status {[0,1,2].sample}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    association :invoice, :item
  end

  factory :bulk_discount do
    sequence(:id)
    percentage_discount {Faker::Number.between(from: 5, to: 50)}
    quantity_threshold {Faker::Number.between(from: 10, to: 100)}
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    association :merchant
  end
end