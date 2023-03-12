require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  describe 'validation' do
    context 'with all required and valid data provided' do
      it { is_expected.to be_valid }
      it { is_expected.to belong_to(:user) }
    end

    context 'without user' do
      it "is invalid and can't be saved" do
        subject.user_id = nil
        expect(subject).to be_invalid
        expect(subject.save).to be_falsey
      end
    end

    context 'without image' do
      # TODO: change to 'is invalid without image and can't be saved' (after model migration)
      it 'is ~~valid~~ and ~~can~~ be saved' do
        subject.image = nil
        expect(subject).to be_valid
        expect(subject.save).to be_truthy
      end
    end

    context 'without caption' do
      it 'is valid and can be saved' do
        subject.caption = nil
        expect(subject).to be_valid
        expect(subject.save).to be_truthy
      end
    end

    context 'with caption length of 2200 chars (max permited number)' do
      it 'is valid and can be saved' do
        subject.caption = FFaker::Lorem.paragraphs(15).join.truncate(2200)
        expect(subject).to be_valid
        expect(subject.save).to be_truthy
      end
    end

    context 'with caption length more than 2200 chars (max permited number)' do
      it "is invalid and can't be saved" do
        subject.caption = FFaker::Lorem.paragraphs(15).join.truncate(2201)
        expect(subject).to be_invalid
        expect(subject.save).to be_falsey
      end
    end
  end
end
