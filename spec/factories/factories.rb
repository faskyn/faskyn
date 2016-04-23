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
    example { Faker::Lorem.sentence }
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
    # factory :product_with_nested_attrs do
    #   after(:build) do |product|
    #     build(:product_feature, product: product)
    #   end
    # end
    trait :product_with_nested_attrs do
      before(:create) do |product|
        # product.product_usecase = create(:product_usecase)
        # product.product_competititon = create(:product_competititon)
        # product.product_feature = create(:product_feature)
        product.product_competitions << build(:product_competition, product: product)
        product.product_usecases << build(:product_usecase, product: product)
        product.product_features << build(:product_feature, product: product)
        #product.industry_products << build(:industry_product, product: product)
        product.industries << build(:industry)
      end
    end

    # trait :with_children do
    #   ignore do
    #     product_competition { build :product_competition }
    #     product_usecase { build :product_usecase }
    #     product_feature { build :product_feature }
    #     industry_product { build :industry_product }
    #     industry { build :industry }
    #   end

    #   after(:build) do |product, evaluator|
    #     if evaluator.product_competitions.present?
    #       product.product_competitions = evaluator.product_competitions
    #     else
    #       product.product_competitions << evaluator.product_competition
    #     end

    #     if evaluator.product_usecases.present?
    #       product.product_usecases = evaluator.product_usecases
    #     else
    #       product.product_usecases << evaluator.product_usecase
    #     end

    #     if evaluator.product_features.present?
    #       product.product_features = evaluator.product_features
    #     else
    #       product.product_features << evaluator.product_feature
    #     end

    #     if evaluator.industry_products.present?
    #       product.industry_products = evaluator.industry_products
    #     else
    #       product.industry_products << evaluator.industry_product
    #     end

    #     if evaluator.industries.present?
    #       product.industries = evaluator.industries
    #     else
    #       product.industries << evaluator.industry
    #     end
    #   end
    # end

    # trait :with_product_all do
    #   ignore do
    #     product_competititon { build :product_competititon , product: product}
    #     product_usecase { build :product_usecase, product: product }
    #     product_feature { build :product_feature, product: product }
    #   end

    #   after(:build) do |product, evaluator|
    #    # If you have to skip validation, add the following line.
    #     product.class.skip_callback(:save, :after, :product_competitions_limit)
    #     product.product_competitions = evaluator.product_competitions

    #     product.class.skip_callback(:save, :after, :product_features_limit)
    #     product.product_features = evaluator.product_features

    #     product.class.skip_callback(:save, :after, :product_usecases_limit)
    #     product.product_usecases = evaluator.product_usecases

    #     product.class.skip_callback(:save, :after, :product_indutries_limit)
    #     product.industries = evaluator.industries
    #   end
    # end


  end
end