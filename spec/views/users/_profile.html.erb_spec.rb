require 'rails_helper'

RSpec.describe 'users/_profile', type: :view do
  subject      { rendered }
  let(:user)   { create :user }
  let(:viewer) { user }

  before do
    sign_in viewer
    assign(:viewer, viewer)
    render partial: 'users/profile', locals: { user: }
  end

  it { should have_selector("div##{dom_id user}") }
  it { should have_selector('h2', text: user.name) }
  it { should have_link(user.name, href: user_path(user).to_s) }
  it { should have_selector('div', text: '0 Posts') }
  it { should have_link('0 Posts', href: user_posts_path(user).to_s) }
  it { should have_selector('div', text: '0 Followers') }
  it { should have_link('0 Followers', href: followers_user_path(user).to_s) }
  it { should render_template(partial: 'relations/_followers_counter', count: 1) }
  it { should have_link('0 Following', href: following_user_path(user).to_s) }
  it { should have_selector('div', text: '0 Following') }

  context 'own profile' do
    it { should_not render_template(partial: 'relations/follow_toggle') }
  end

  context "other user's profile" do
    let(:viewer) { create :user }

    it do
      should render_template(
        partial: 'relations/follow_toggle',
        count: 1,
        locals: { user:,
                  relation: viewer.active_relations.find_by(followed: user) }
      )
    end
  end

  context 'with content' do
    before do
      create_list(:post, 5, user:)
      create_list(:relation, 4, followed: user)
      create_list(:relation, 3, follower: user)
      render partial: 'users/profile', locals: { user: }
    end

    it { should have_selector('div', text: '5 Posts') }
    it { should have_selector('div', text: '4 Followers') }
    it { should have_link('5 Posts', href: user_posts_path(user).to_s) }
    it { should have_link('4 Followers', href: followers_user_path(user).to_s) }
    it { should have_link('3 Following', href: following_user_path(user).to_s) }
  end
end
