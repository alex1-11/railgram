require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)    { create :user }
  let(:request) { get :show, params: { id: user.id } }

  before do
    sign_in user
    request
  end

  describe 'GET #show' do
    context 'signed in user trying to view his/her own user page' do
      it 'assigns user instance variable with user from request' do
        expect(assigns(:user)).to eq(user)
      end

      it { should permit(:id).for(:show, verb: :get, params: { id: user.id }) }
      it { should redirect_to user_posts_path(user) }
    end

    context 'trying to view other user page' do
      let(:other_user) { create :user }
      let(:request)    { get :show, params: { id: other_user.id } }

      it 'assigns user instance variable with user from request' do
        expect(assigns(:user)).to eq(other_user)
      end

      it { should permit(:id).for(:show, verb: :get, params: { id: other_user.id }) }
      it { should redirect_to user_posts_path(other_user) }
    end
  end

  describe 'GET #settings' do
    let(:request) { get :settings }

    it { should render_template(:settings) }
  end

  describe 'DELETE #destroy' do
    let(:request_delete) { delete :destroy, params: { id: user.id } }

    context 'own account' do
      it 'destroys the user' do
        expect { request_delete }.to change(User, :count).by(-1)
      end

      it 'redirects to root route' do
        expect(request_delete).to redirect_to :root 
      end

      it 'flashes notice of successful deletion' do
        request_delete
        expect(flash[:notice]).to eq('User was successfully destroyed.')
      end
    end

    context 'maliciously replacing request with other user account' do
      let(:other_user)     { create :user }
      let(:request_delete) { delete :destroy, params: { id: other_user.id } }

      it 'destroys the calling user, not other user' do
        request_delete
        expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(User.find(other_user.id)).to eq(other_user)
      end
    end
  end
end
