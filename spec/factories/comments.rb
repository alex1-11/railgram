FactoryBot.define do
  factory :comment do
    user
    post
    text { FFaker::Lorem.paragraphs.join }
  end

  trait :with_too_long_text do
    text { FFaker::Lorem.characters(3000) }
  end
end
