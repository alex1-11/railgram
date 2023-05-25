require 'rails_helper'

RSpec.describe 'relations/_follow_toggle', type: :view do
  subject       { rendered }
  let(:user)    { create :user }
  let(:blogger) { create :user }

  before do
    sign_in user
    render partial: 'relations/follow_toggle', locals: { user: blogger }
  end

  it { should have_selector('turbo-frame#follow_toggle') }

  context 'user does not follow the other user' do
    it { should have_selector("form[action='#{relations_path}'][method='post']") }
    it { should have_selector("input[name='followed_id'][type='hidden'][value='#{blogger.id}']", visible: false) }
    it { should have_selector("button[type='submit']", text: 'Follow') }
  end

  context 'user already follows the other user' do
    let(:relation) { create :relation, follower: user, followed: blogger }

    before do
      relation
      render partial: 'relations/follow_toggle', locals: { user: blogger, relation: }
    end

    it { should have_selector("form[action='#{relation_path(relation)}'][method='post']") }
    it { should have_selector("input[name='_method'][type='hidden'][value='delete']", visible: false) }
    it { should have_selector("input[name='followed_id'][type='hidden'][value='#{blogger.id}']", visible: false) }
    it { should have_selector("input[name='id'][type='hidden'][value='#{relation.id}']", visible: false) }
    it { should have_selector("button[type='submit']", text: 'Unfollow') }
  end
end
