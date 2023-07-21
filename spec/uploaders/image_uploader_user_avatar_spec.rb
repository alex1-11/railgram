require 'rails_helper'
require 'image_processing/vips'

RSpec.describe ImageUploader do
  describe 'avatar for user' do
    let(:user)        { create(:user, avatar: File.open('spec/support/images/sample_1280x720.jpg', 'rb')) }
    let(:avatar)      { user.avatar }
    let(:derivatives) { user.avatar_derivatives }

    it 'extracts metadata' do
      expect(avatar.mime_type).to eq('image/jpeg')
      expect(avatar.extension).to eq('jpg')
      expect(avatar.size).to be_instance_of(Integer)
      expect(avatar.width).to be_instance_of(Integer)
      expect(avatar.height).to be_instance_of(Integer)
    end

    describe 'validation' do
      context 'correct avatar file' do
        it 'passes validation' do
          expect(user.errors).to be_empty
        end
      end

      context 'too large (size-vise) file' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_size_large') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar size must not be greater than 10.0 MB')
        end
      end

      context 'too small (size-vise) file' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_size_small') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar size must not be less than 1.0 KB')
        end
      end

      context 'wrong mime (non-image file under image extension)' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_mime') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar type must be one of: image/jpeg, image/png, image/webp')
        end
      end

      context 'wrong file extension' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_extention') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar extension must be one of: jpg, jpeg, png, webp')
        end
      end

      context 'too wide image' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_width') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar dimensions must not be greater than 5000x5000')
        end
      end

      context 'too high image' do
        let(:user) { create(:user, :with_avatar, version: 'invalid_hight') }

        it 'raises error' do
          expect { user.save }.to raise_error(ActiveRecord::RecordInvalid,
                                              'Validation failed: Avatar dimensions must not be greater than 5000x5000')
        end
      end
    end

    describe 'derivatives' do
      context 'before saving avatar image to storage (promoting image, storing user.avatar in db`s row)' do
        let(:user) { build(:user) }

        it 'derivatives are nil' do
          expect(derivatives[:profile_pic]).to be_nil
          expect(derivatives[:thumbnail]).to be_nil
        end
      end

      context 'after saving 1920x1280 avatar to storage (promoting)' do
        let(:user) { create(:user, avatar: File.open('spec/support/images/sample_1920x1280.jpg', 'rb'), avatar_data: {}) }

        it 'generates derivatives for avatar' do
          expect(derivatives[:profile_pic]).to be_kind_of(Shrine::UploadedFile)
          expect(derivatives[:thumbnail]).to be_kind_of(Shrine::UploadedFile)
        end

        it 'resizes to fill 180x180' do
          expect(avatar.width).to eq(1920)
          expect(avatar.height).to eq(1280)
          expect(derivatives[:profile_pic].width).to eq(180)
          expect(derivatives[:profile_pic].height).to eq(180)
        end

        it 'creates 50x50 thumbnail' do
          expect(derivatives[:thumbnail].width).to eq(50)
          expect(derivatives[:thumbnail].height).to eq(50)
        end
      end

      context 'after saving 427x640 avatar to storage (promoting)' do
        let(:user) { create(:user, avatar: File.open('spec/support/images/sample_427x640.jpg', 'rb'), avatar_data: {}) }

        it 'resizes to fill 180x180' do
          expect(avatar.width).to  be > derivatives[:profile_pic].width
          expect(avatar.height).to be > derivatives[:profile_pic].height
          expect(derivatives[:profile_pic].width).to eq(180)
          expect(derivatives[:profile_pic].height).to eq(180)
        end

        it 'creates 50x50 thumbnail' do
          expect(derivatives[:thumbnail].width).to eq(50)
          expect(derivatives[:thumbnail].height).to eq(50)
        end
      end
    end
  end
end
