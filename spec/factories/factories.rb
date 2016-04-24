FactoryGirl.define do
  factory :user do
    #email { Faker::Internet.email }
    sequence(:email) { |n| "example#{n}@gmail.com" }
    #sequence(:email) { Faker::Internet.email }
    confirmed_at { Faker::Time.between(DateTime.now - 1, DateTime.now - 2) }
    password 'example0000'
    password_confirmation 'example0000'
    new_chat_notification { Faker::Number.between(0, 10) }
    new_other_notification { Faker::Number.between(0, 10) } 
  end

  factory :profile do
    first_name { "John" }
    last_name { "Doe" }
    job_title { Faker::Name.title }
    company { "Faskyn" }
    avatar { Faker::Avatar.image }
    location { Faker::Address.city }
    description { Faker::Lorem.sentence }
    phone_number { Faker::PhoneNumber.cell_phone }
    # image.image  fixture_file_upload( Rails.root + 'spec/fixtures/images/example.jpg', "image/jpg")
    # image.caption           "Some random caption"
    user
  end

  factory :social do
    uid { Faker::Number.number(8) }
    token { Faker::Number.number(10) }
    first_name { "John" }
    last_name { "Doe" }
    provider { "twitter"}
    page_url { "https://twitter.com/jdoe" }
    profile
  end

  factory :notification do
    notifiable_id { Faker::Number.between(1, 10) }
    notifiable_type { Faker::Lorem.word }
    action { Faker::Hipster.word }
    checked_at { Faker::Time.between(DateTime.now - 2, DateTime.now - 3)  }
    association :sender, factory: :user
    association :recipient, factory: :user
  end

  factory :task do
    content { Faker::Lorem.sentence }
    deadline { Faker::Time.between(DateTime.now + 2, DateTime.now + 3) }
    association :executor, factory: :user
    association :assigner, factory: :user
  end

  factory :conversation do
    association :sender, factory: :user
    association :recipient, factory: :user
  end

  factory :message do
    user
    conversation

    factory :message_with_body do
      body { Faker::Lorem.paragraph }
    end

    factory :message_with_attachment do
      message_attachment_id { Faker::Number.between(1, 10) }
      message_attachment_filename "file.pdf"
    end
  end

  factory :post do
    body { Faker::Lorem.paragraph }
    post_image { Faker::Avatar.image }
    user
  end

  factory :post_comment do
    body { Faker::Lorem.sentence }
    post
    user
  end

  factory :post_comment_reply do
    body { Faker::Lorem.sentence }
    post_comment
    user
  end

  factory :product_competition, class: ProductCompetition do
    competitor { Faker::Commerce.product_name }
    differentiator { Faker::Lorem.paragraph }
    #product
  end

  factory :product_feature, class: ProductFeature do
    feature { Faker::Lorem.paragraph }
    #product
  end

  factory :product_usecase, class: ProductUsecase do
    example { Faker::Lorem.sentence(3) }
    detail { Faker::Lorem.paragraph }
    #product
  end


  factory :industry, class: Industry do
    name "AI"
  end

  factory :industry_product, class: IndustryProduct do
    #product
    industry
  end

  factory :product, class: Product do
    name { Faker::Commerce.product_name }
    company { Faker::Company.name }
    website { 'https://example.com' }
    oneliner { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
    trait :product_with_nested_attrs do
      before(:create) do |product|
        product.product_competitions << build(:product_competition, product: product)
        product.product_usecases << build(:product_usecase, product: product)
        product.product_features << build(:product_feature, product: product)
        product.industries << build(:industry)
      end
    end
    trait :product_for_create_action do
      before(:create) do |product|
        product.product_competitions << attributes_for(:product_competition, product: product)
        product.product_usecases << attributes_for(:product_usecase, product: product)
        product.product_features << attriubtes_for(:product_feature, product: product)
        product.industries << attributes_for(:industry)
      end
    end
    trait :product_2_for_create_action do
      after(:build) do |product|
        product.product_competitions << build(:product_competition, product: product)
        product.product_usecases << build(:product_usecase, product: product)
        product.product_features << build(:product_feature, product: product)
        product.industries << build(:industry)
      end
    end
  end
end