FactoryBot.define do
  factory :relation do
    follower { association :user }
    followed { association :user }
  end
end
