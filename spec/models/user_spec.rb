require 'rails_helper'

RSpec.describe User, type: :model do
  # describe 'validations' do
  #   subject { build(:user) }

  #   it 'is a valid object' do
  #     expect(subject).to be_valid
  #   end

  #   it 'is not valid without an email' do
  #     subject.email = nil
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid without a name' do
  #     subject.name = nil
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid without a password' do
  #     subject.password = nil
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with a duplicate email' do
  #     create(:user, email: subject.email)
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with a duplicate name' do
  #     create(:user, name: subject.name)
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with an email length less than 5 chars' do
  #     subject.email = FFaker::Lorem.characters(4)
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with a name length less than 3 chars' do
  #     subject.name = FFaker::Lorem.characters(2)
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with a name length more than 30 chars' do
  #     subject.name = FFaker::Lorem.characters(31)
  #     expect(subject).not_to be_valid
  #   end

  #   it 'is not valid with a password length less than 6 chars' do
  #     subject.password = FFaker::Lorem.characters(5)
  #     expect(subject).not_to be_valid
  #   end
  # end

  describe 'associations' do
    # it { should have_many(:posts) }
    # it { should have_many(:likes) }
    # it { should have_many(:liked_posts) }
    # it { should have_many(:comments) }
    # it { should have_many(:active_relations) }
    # it { should have_many(:passive_relations) }
    # it { should have_many(:following) }

    describe 'relations' do
      let(:user)     { create :user }
      let(:user2)    { create :user }
      let(:relation) { build(:relation, follower: user, followed: user2) }

      it 'shows users which the user is following' do
        relation.save
        relation2 = create(:relation, follower: user)
        expect(user.following).to include(user2)
        expect(user.following).to include(relation2.followed)
        expect(user.following).to eq([user2, relation2.followed])
      end

      it 'shows followers of the user' do
      end

      it 'follows/unfollows a user, creating/destroying a relation' do
        expect(user2.follows?(user)).to be_falsey

        expect { user2.follow(user) }.to change(Relation, :count).by(1)
        expect(user2.follows?(user)).to be_truthy

        expect { user2.unfollow(user) }.to change(Relation, :count).by(-1)
        expect(user2.follows?(user)).to be_falsey
      end
    end
  end
end

# TODO: https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
