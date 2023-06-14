require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { build(:post) }

  describe 'association' do
    it { should belong_to(:user).counter_cache(true) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liking_users).through(:likes).source(:user) }
    it { should have_many(:comments).dependent(:destroy) }

    it 'has associated valid image with data and post_size derivative version' do
      subject.save
      expect(subject.image).to be_kind_of(ImageUploader::UploadedFile)
      expect(subject.image(:post_size)).to be_kind_of(ImageUploader::UploadedFile)
    end
  end

  describe 'validation' do
    it { should validate_length_of(:caption).is_at_most(2200) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:image_data) }

    context 'with all required and valid data provided' do
      it 'is valid and can be saved' do
        expect(subject).to be_valid
        expect(subject.save).to be_truthy
      end
    end

    context 'without user' do
      it "is invalid and can't be saved" do
        subject.user_id = nil
        expect(subject).to be_invalid
        expect(subject.save).to be_falsey
      end
    end

    context 'without image' do
      it "is invalid and can't be saved" do
        subject.image = nil
        expect(subject).to be_invalid
        expect(subject.save).to be_falsey
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

  describe "callbacks" do
    it "sets default counter cache values after initialization" do
      expect(subject.likes_count).to eq(0)
      expect(subject.comments_count).to eq(0)
    end
  end
end
