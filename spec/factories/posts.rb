FactoryBot.define do
  factory :post do
    user { build(:user).id } # FIXME

    # Generating random paragraph with character length limit
    caption { FFaker::Lorem.paragraph[0..2200] }

    # TODO: testing of shrine gem image uploading
    # image
  end
end
