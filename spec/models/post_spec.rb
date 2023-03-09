require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    subject { build(:post) }
    it { is_expected.to be_valid }
  end
end
