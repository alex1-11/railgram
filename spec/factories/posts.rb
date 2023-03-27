require_relative 'test_data'

FactoryBot.use_parent_strategy = false # config for auto creation of User record
FactoryBot.define do
  factory :post do
    # Association with user factory to fill in user_id parameter (see https://github.com/thoughtbot/factory_bot/blob/main/GETTING_STARTED.md#build-strategies-1)
    user

    # Generates random paragraph with character length limit
    caption { FFaker::Lorem.paragraphs.join }

    # Allows to choose which image version to build (default: 'valid')
    transient do
      version { 'valid' }
    end

    # Image uploaded by shrine gem (see test_data.rb)
    image { TestData.uploaded_image(version) }

    # Image metadata
    image_data { TestData.image_data(version) }

    # Made for controller testing. Simulates file attached and submited via html form
    trait :simulate_form_upload do
      image_data {}
      image do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'support', 'images', 'sample_1280x720.jpg'),
          'image/jpeg'
        )
      end
    end

    trait :with_too_long_caption_only do
      caption     { FFaker::Lorem.characters(3000) }
      image       { nil }
      image_data  { nil }
    end

    trait :empty do
      caption     { nil }
      image       { nil }
      image_data  { nil }
    end
  end
end
