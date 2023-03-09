# Reference material https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#update-your-gemfile

# TODO: check and finish
FactoryBot.define do
  factory :user do
    email { 'Wick@john.com' }
    password  { 'password' }
    password_confirmation { 'password' }
  end
end
