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
      let(:blogger)  { create :user }
      let(:relation) { create(:relation, follower: user, followed: blogger) }

      before { relation }

      it 'shows users which the user is following' do
        expect(user.following).to include(blogger)
        relation2 = create(:relation, follower: user)
        expect(user.following).to include(relation2.followed)
        expect(user.following).to eq([blogger, relation2.followed])
      end

      it 'shows followers of the user' do
        expect(blogger.followers).to include(user)
        relation2 = create(:relation, followed: blogger)
        expect(blogger.followers).to include(relation2.follower)
        expect(blogger.followers).to eq([user, relation2.follower])
      end

      it 'follows/unfollows a user, creating/destroying a relation' do
        relation.destroy
        expect(user.follows?(blogger)).to be_falsey
        expect(blogger.followers).to_not include(user)

        expect { user.follow(blogger) }.to change(Relation, :count).by(1)
        expect(user.follows?(blogger)).to be_truthy
        blogger.reload
        expect(blogger.followers).to include(user)

        expect { user.unfollow(blogger) }.to change(Relation, :count).by(-1)
        expect(user.follows?(blogger)).to be_falsey
        expect(blogger.followers).to_not include(user)
      end
    end
  end
end

# TODO: https://github.com/heartcombo/devise/wiki/How-To:-Test-controllers-with-Rails-(and-RSpec)
