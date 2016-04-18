# FactoryGirl.define do

#   factory :product_competititon, class: ProductCompetition do
#     competitor { Faker::Commerce.product_name }
#     differentiator { Faker::Lorem.paragraph }
#     product
#   end

#   factory :product_feature, class: ProductFeature do
#     feature { Faker::Lorem.paragraph }
#     product
#   end

#   factory :product_usecase, class: ProductUsecase do
#     example { Faker::Lorem.sentence }
#     detail { Faker::Lorem.paragraph }
#     product
#   end

#   factory :industry_product, class: IndustryProduct do
#     product
#     industry
#   end 

#   factory :product, class: Product do
#     name { Faker::Commerce.product_name }
#     company { Faker::Company.name }
#     website { 'https://example.com' }
#     oneliner { Faker::Lorem.sentence }
#     description { Faker::Lorem.paragraph }
#     user
#     # factory :product_with_nested_attrs do
#     #   after(:build) do |product|
#     #     build(:product_feature, product: product)
#     #   end
#     # end
#     trait :product_with_nested_attrs do
#       after(:create) do |product|
#         # product.product_usecase = create(:product_usecase)
#         # product.product_competititon = create(:product_competititon)
#         # product.product_feature = create(:product_feature)
#         create(:product_competititon, product: product)
#         create(:product_usecase, product: product)
#         create(:product_feature, product: product)
#       end
#     end
#   end
# end
