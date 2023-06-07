require 'rails_helper'

RSpec.describe Relation, type: :model do
  let(:user)     { create :user }
  subject        { build(:relation, follower: user) }

  describe 'basic functionality' do
    it 'is a valid object and can be saved' do
      should be_valid
      expect { subject.save }.to change(Relation, :count).by(1)
    end
  end

  describe 'validation' do
    it 'requires a follower_id' do
      expect(subject.follower_id).to_not be_nil
      expect(subject).to be_valid
      should validate_presence_of(:follower_id)

      subject.follower_id = nil
      expect(subject).to be_invalid
      expect(subject.save).to be_falsey
    end

    it 'requires a followed_id' do
      expect(subject.followed_id).to_not be_nil
      expect(subject).to be_valid
      should validate_presence_of(:followed_id)

      subject.followed_id = nil
      expect(subject).to be_invalid
      expect(subject.save).to be_falsey
    end
  end

  describe 'association' do
    it { should belong_to(:follower).class_name('User').counter_cache(:following_count) }
    it { should belong_to(:followed).class_name('User').counter_cache(:followers_count) }

    it 'can create active and passive relation between users' do
      subject.save
      expect(user.active_relations.last).to eq(subject)
      expect(subject.followed.passive_relations.last).to eq(subject)
    end
  end
end
