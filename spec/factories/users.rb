# Reference material https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#update-your-gemfile

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name do
      sample = FFaker::Internet.user_name until sample.length >= 3
      sample
    end
    password { 'password' }
  end
end
