require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe 'GET #show' do
    let(:user) { create :user }
    let(:request) { get :show, params: { id: user.id } }

    before do
      sign_in user
      request
    end

    it 'assigns user instance variable with user from request' do
      expect(assigns(:user)).to eq(user)
    end

    it { should permit(:id).for(:show, verb: :get, params: { id: user.id }) }
    it { should redirect_to user_posts_path(user) }
  end
  
end
