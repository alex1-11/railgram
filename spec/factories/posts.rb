require_relative '../support/images/test_data'

FactoryBot.use_parent_strategy = false
FactoryBot.define do

  factory :post do
    # Association with user factory to fill in user_id parameter (see https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#build-strategies-1)
    user

    # Generates random paragraph with character length limit
    caption { FFaker::Lorem.paragraphs }

    # TODO: testing of shrine gem image uploading
    image_data { TestData.image_data }
  end
end
