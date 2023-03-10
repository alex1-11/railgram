# Reference material https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#update-your-gemfile

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Internet.user_name }
    password { 'password' }
  end
end
