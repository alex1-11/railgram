require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    subject { create(:post) }

    it { is_expected.to be_valid }
    it { is_expected.to belong_to(:user) }

    it "is invalid without user and can't be saved" do
      subject.user_id = nil
      expect(subject).to be_invalid
      expect(subject.save).to be_falsey
    end

    it 'is valid without caption and can be saved' do
      subject.caption = nil
      expect(subject).to be_valid
      expect(subject.save).to be_truthy
    end

    it 'is valid with caption length of 2200 chars and can be saved' do
      subject.caption = FFaker::Lorem.paragraphs(15).join.truncate(2200)
      expect(subject).to be_valid
      expect(subject.save).to be_truthy
    end

    it "is invalid with caption length more than 2200 chars and can't be saved" do
      subject.caption = FFaker::Lorem.paragraphs(15).join.truncate(2201)
      expect(subject).to be_invalid
      expect(subject.save).to be_falsey
    end
  end
end
