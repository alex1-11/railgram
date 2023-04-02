require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    subject { get :index }

    context 'when user is signed in' do
      let(:user) { create(:user) }
      before { sign_in user }

      it "redirects to user's posts" do
        subject
        expect(response).to redirect_to(user_posts_url(user))
      end
    end

    context 'when user is not signed in' do
      # before { sign_out(:user) } # Can leave commented out, no user was created

      it 'renders the index template' do
        subject
        expect(response).to render_template(:index)
      end
    end
  end
end
