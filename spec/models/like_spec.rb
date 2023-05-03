require 'rails_helper'

RSpec.describe Like, type: :model do
  subject { build(:like) }

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validation' do
    context 'with nil user data' do
      before { subject.user_id = nil }
      it { should be_invalid }
    end

    context 'with nil post data' do
      before { subject.post_id = nil }
      it { should be_invalid }
    end
  end
end
