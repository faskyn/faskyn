FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@gmail.com" }
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
    avatar { "default.png" }
    location { Faker::Address.city }
    description { Faker::Lorem.sentence }
    phone_number { Faker::PhoneNumber.cell_phone }
    created_at  { DateTime.now - 4 }
    updated_at { DateTime.now - 2 }
    # image.image  fixture_file_upload( Rails.root + 'spec/fixtures/images/example.jpg', "image/jpg")
    # image.caption           "Some random caption"
    user
    # after :create do |b|
    #   b.update_column(:avatar, "default.png")
    # end
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

  factory :product_customer, class: ProductCustomer do
    customer { Faker::Company.name }
    usage { Faker::Lorem.paragraph }
    website { 'https://examplecustomer.com' }
    #product
  end

  factory :product_lead, class: ProductLead do
    lead { Faker::Company.name }
    pitch { Faker::Lorem.paragraph }
  end

  factory :industry, class: Industry do
    name "AI"
  end

  factory :industry_product, class: IndustryProduct do
    industry
  end

  factory :product_user do
    role "member"
    user
  end

  factory :product_invitation do
    accepted false
  end

  factory :product, class: Product do
    sequence(:name) { |n| "ABC_#{n}" }
    website { 'https://example.com' }
    oneliner { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    trait :product_with_nested_attrs do
      before(:create) do |product|
        product.product_customers << build(:product_customer, product: product)
        product.product_leads << build(:product_lead, product: product)
        product.industries << build(:industry)
        product.product_users << build(:product_user)
      end
    end
  end

  factory :contact, class: Contact do
    name { "John Doe" }
    email { Faker::Internet.email }
    comment { Faker::Lorem.paragraph }
  end
end