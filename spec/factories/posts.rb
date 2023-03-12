FactoryBot.define do

  factory :post do
    # Association with user factory to fill in user_id parameter
    user

    # Generates random paragraph with character length limit
    caption { FFaker::Lorem.paragraphs }

    # TODO: testing of shrine gem image uploading
    image_data { TestData.image_data }
  end
end
