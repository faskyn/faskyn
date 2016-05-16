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

  # factory :auth_hash do
  #   uid { Faker::Number.number(8) }
  #   token { Faker::Number.number(10) }
  #   first_name { "John" }
  #   last_name { "Doe" }
  #   provider { "twitter"}
  #   page_url { "https://twitter.com/jdoe" }
  # end

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

    factory :message_with_link do
      link { Faker::Internet.url }
    end
  end

  factory :post do
    body { Faker::Lorem.paragraph }
    post_image { Faker::Avatar.image }
    user
  end

  factory :comment do
    body { Faker::Lorem.sentence }
    user
  end

  factory :comment_reply do
    body { Faker::Lorem.sentence }
    comment
    user
  end

  factory :product_usecase, class: ProductUsecase do
    example { Faker::Lorem.sentence(3) }
    detail { Faker::Lorem.paragraph }
    #product
  end

  factory :product_customer, class: ProductCustomer do
    customer { Faker::Company.name }
    usage { Faker::Lorem.paragraph }
    #product
  end

  factory :product_lead, class: ProductLead do
    lead { Faker::Company.name }
    pitch { Faker::Lorem.paragraph }
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
    #name { Faker::Commerce.product_name }
    sequence(:name) { |n| "ABC_#{n}" }
    website { 'https://example.com' }
    oneliner { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    user
    trait :product_with_nested_attrs do
      before(:create) do |product|
        product.product_usecases << build(:product_usecase, product: product)
        product.product_customers << build(:product_customer, product: product)
        product.product_leads << build(:product_lead, product: product)
        product.industries << build(:industry)
      end
    end
  end

  factory :contact, class: Contact do
    name { "John Doe" }
    email { Faker::Internet.email }
    comment { Faker::Lorem.paragraph }
  end
end