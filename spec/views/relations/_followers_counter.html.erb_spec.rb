require 'rails_helper'

RSpec.describe 'relations/_followers_counter', type: :view do
  subject       { rendered }
  let(:user)    { create :user }
  let(:blogger) { create :user }

  before do
    sign_in user
    render partial: 'relations/followers_counter', locals: { user: blogger }
  end

  it { should have_selector('turbo-frame#followers_counter') }

  context 'user has no followers' do
    it { should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']", text: '0 Followers') }
  end

  context 'user has one follower' do
    let(:relation) { create :relation, followed: blogger }

    before do
      relation
      render partial: 'relations/followers_counter', locals: { user: blogger }
    end

    it { should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']", text: '1 Follower') }
  end

  context 'user has several followers' do
    let(:relation) { create_list :relation, 5, followed: blogger }

    before do
      relation
      render partial: 'relations/followers_counter', locals: { user: blogger }
    end

    it { should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']", text: '5 Followers') }
  end
end
