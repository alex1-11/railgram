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

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:email).is_at_least(5).is_at_most(256) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(30) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_posts).through(:likes).source(:post) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:active_relations).class_name('Relation').with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:passive_relations).class_name('Relation').with_foreign_key('followed_id').dependent(:destroy) }
    it { should have_many(:following).through(:active_relations).source(:followed) }
    it { should have_many(:followers).through(:passive_relations).source(:follower) }
  end

  describe 'relation helper methods' do
    let(:user)    { create :user }
    let(:blogger) { create :user }

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

    describe 'follow(user) relation helper' do
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

      it 'restricts double following and returns existing relation' do
        expect { user.follow(blogger) }.to_not change(Relation, :count)
        expect(user.follow(blogger)).to eq(relation)
      end

      it 'restricts self following' do
        expect { user.follow(user) }.to_not change(Relation, :count)
        expect(user.follow(user)).to be_falsey
      end
    end
  end

  describe 'callbacks' do
    let(:user) { build :user }

    it 'sets default counters cache values' do
      expect(user.posts_count).to eq(0)
      expect(user.followers_count).to eq(0)
      expect(user.following_count).to eq(0)
    end
  end

  describe 'roll_user, the easter_egg feature helper' do
    let(:user) { create :user }

    it 'changes default `false` value to `true`' do
      expect(user.rolled).to be_falsey
      user.roll_user
      expect(user.rolled).to be_truthy
    end
  end
end
