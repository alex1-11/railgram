require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it 'is a valid object' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      create(:user, email: subject.email)
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate name' do
      create(:user, name: subject.name)
      expect(subject).not_to be_valid
    end

    it 'is not valid with an email length less than 5 chars' do
      subject.email = FFaker::Lorem.characters(4)
      expect(subject).not_to be_valid
    end

    it 'is not valid with a name length less than 3 chars' do
      subject.name = FFaker::Lorem.characters(2)
      expect(subject).not_to be_valid
    end

    it 'is not valid with a name length more than 30 chars' do
      subject.name = FFaker::Lorem.characters(31)
      expect(subject).not_to be_valid
    end

    it 'is not valid with a password length less than 6 chars' do
      subject.password = FFaker::Lorem.characters(5)
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:posts) }
  end
end

# TODO: https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
