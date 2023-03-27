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
  end
end
