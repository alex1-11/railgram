require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build :comment }

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validation' do
    context 'valid data' do
      it { should be_valid }
      it 'saves to database successfully' do
        expect(subject.save).to be_truthy
      end
    end

    context 'with nil user data' do
      before { subject.user_id = nil }

      it { should be_invalid }
    end

    context 'with nil post data' do
      before { subject.post_id = nil }

      it { should be_invalid }
    end

    context 'with nil text data' do
      before { subject.text = nil }

      it { should be_invalid }
    end

    context 'with too long text data' do
      subject { build :comment, :with_too_long_text }

      it { should be_invalid }
    end
  end
end
