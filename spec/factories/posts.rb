require_relative 'test_data'

FactoryBot.use_parent_strategy = false # config for auto creation of User record
FactoryBot.define do

  factory :post do
    # Association with user factory to fill in user_id parameter (see https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#build-strategies-1)
    user

    # Generates random paragraph with character length limit
    caption { FFaker::Lorem.paragraphs.join }

    # Image uploaded by shrine gem (see test_data.rb)
    image { TestData.uploaded_image }

    # Image metadata
    image_data { TestData.image_data }

    trait :with_real_metadata do
      image { TestData.uploaded_image('real_metadata') }
      image_data { TestData.image_data('real_metadata') }
    end
  end
end
