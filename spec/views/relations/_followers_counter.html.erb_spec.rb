require 'rails_helper'

RSpec.describe 'relations/_followers_counter', type: :view do
  subject       { rendered }
  let(:user)    { create :user }
  let(:blogger) { create :user }

  before        { sign_in user }

  context 'user has no followers' do
    before { render partial: 'relations/followers_counter', locals: { user: blogger } }

    it { should have_selector('turbo-frame#followers_counter') }
    it do
      should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']",
                           text: "\n    0\n    \n    Followers\n")
    end
  end

  context 'user has one follower' do
    let(:relation) { create :relation, followed: blogger }

    before do
      relation
      render partial: 'relations/followers_counter', locals: { user: blogger }
    end

    it { should have_selector('turbo-frame#followers_counter') }
    it do
      should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']",
                           text: "\n    1\n    \n    Follower\n")
    end
  end

  context 'user has several followers' do
    let(:relation) { create_list :relation, 5, followed: blogger }

    before do
      relation
      render partial: 'relations/followers_counter', locals: { user: blogger }
    end

    it { should have_selector('turbo-frame#followers_counter') }
    it do
      should have_selector("a[href='#{followers_user_path(blogger)}'][target='_top']",
                           text: "\n    5\n    \n    Followers\n")
    end
  end
end
