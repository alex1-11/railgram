require_relative 'test_data'
# Reference material https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#update-your-gemfile

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name do
      # Sets username with minimal length of 3 chars
      sample = nil
      loop do
        sample = FFaker::Internet.user_name
        break if sample.length >= 3
      end
      sample
    end
    password { 'password' }

    # Avatar section powered by Shrine gem and TestData preset helper

    # Allows to pass key to choose which image version to build (default: 'valid') using preset TestData module for testing images
    transient do
      version { 'avatar' }
    end

    trait :with_avatar do
      avatar      { TestData.uploaded_image(version) } # Image uploaded by shrine gem (see test_data.rb)
      avatar_data { TestData.image_data(version) }     # Image metadata
    end

    # Made for controller testing. Simulates file attached and submited via html form
    trait :simulate_avatar_form_upload do
      avatar_data {}
      avatar do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'support', 'images', 'sample_1280x720.jpg'),
          'image/jpeg'
        )
      end
    end

    trait :uploades_avatar_with_wrong_ext do
      avatar_data {}
      avatar do
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec', 'support', 'images', 'jpg_wrong_extension.txt'),
          'image/jpeg'
        )
      end
    end
  end
end
