require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)    { create :user }
  let(:request) {}

  before do
    sign_in user
    request
  end

  # it { should use_before_action(:set_user) }

  # describe 'GET #show' do
  #   let(:request) { get :show, params: { id: user.id } }

  #   it { should permit(:id).for(:show, params: { id: user.id }, verb: :get) }

  #   context 'signed in user trying to view his/her own user page' do
  #     before { create_list(:post, 3, user:) }

  #     it 'assigns user and posts instance variables with user from request' do
  #       expect(assigns(:user)).to eq(user)
  #       expect(assigns(:posts)).to match_array(user.posts)
  #     end

  #     it 'assigns posts in descending order of creation datetime' do
  #       expect(assigns(:posts)[0].created_at > assigns(:posts)[1].created_at).to be_truthy
  #       expect(assigns(:posts)[1].created_at > assigns(:posts)[2].created_at).to be_truthy
  #     end

  #     it { should permit(:id).for(:show, verb: :get, params: { id: user.id }) }
  #     it { should render_template(:show) }
  #   end

  #   context 'trying to view other user page' do
  #     let(:other_user) { create :user }
  #     let(:request)    { get :show, params: { id: other_user.id } }

  #     before { create_list(:post, 3, user: other_user) }

  #     it 'assigns user and posts instance variables with user from request' do
  #       expect(assigns(:user)).to eq(other_user)
  #       expect(assigns(:posts)).to match_array(other_user.posts)
  #     end

  #     it 'assigns posts in descending order of creation datetime' do
  #       expect(assigns(:posts)[0].created_at > assigns(:posts)[1].created_at).to be_truthy
  #       expect(assigns(:posts)[1].created_at > assigns(:posts)[2].created_at).to be_truthy
  #     end

  #     it { should permit(:id).for(:show, verb: :get, params: { id: other_user.id }) }
  #     it { should render_template(:show) }
  #   end
  # end

  # describe 'GET #settings' do
  #   let(:request) { get :settings }

  #   it { should render_template(:settings) }
  # end

  # describe 'DELETE #destroy' do
  #   let(:request_delete) { delete :destroy, params: { id: user.id } }

  #   context 'own account' do
  #     it 'destroys the user' do
  #       expect { request_delete }.to change(User, :count).by(-1)
  #     end

  #     it 'redirects to root route' do
  #       expect(request_delete).to redirect_to :root 
  #     end

  #     it 'flashes notice of successful deletion' do
  #       request_delete
  #       expect(flash[:notice]).to eq('User was successfully destroyed.')
  #     end
  #   end

  #   context 'maliciously replacing request with other user account' do
  #     let(:other_user)     { create :user }
  #     let(:request_delete) { delete :destroy, params: { id: other_user.id } }

  #     it 'destroys the calling user, not other user' do
  #       request_delete
  #       expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
  #       expect(User.find(other_user.id)).to eq(other_user)
  #     end
  #   end
  # end

  # describe 'GET #followers' do
  #   let(:other_user) { create :user }
  #   let(:request)    { get :followers, params: { id: other_user.id } }

  #   before do
  #     create_list(:relation, 3, followed: other_user)
  #     request
  #   end

  #   it { should permit(:id).for(:followers, params: { id: other_user.id }, verb: :get) }

  #   it 'assigns user instance variable with user from request' do
  #     expect(assigns(:user)).to eq(other_user)
  #   end

  #   it 'assigns user followers to @followers' do
  #     expect(assigns(:followers)).to match_array(other_user.followers)
  #   end

  #   it { should render_template(:followers) }
  # end

  # describe 'GET #following' do
  #   let(:other_user) { create :user }
  #   let(:request)    { get :following, params: { id: other_user.id } }

  #   before do
  #     create_list(:relation, 3, follower: other_user)
  #     request
  #   end

  #   it { should permit(:id).for(:following, params: { id: other_user.id }, verb: :get) }

  #   it 'assigns user instance variable with user from request' do
  #     expect(assigns(:user)).to eq(other_user)
  #   end

  #   it 'assigns user following to @following' do
  #     expect(assigns(:following)).to match_array(other_user.following)
  #   end

  #   it { should render_template(:following) }
  # end

  describe 'GET #easter_egg' do
    let(:request_easter_egg) { get :easter_egg }

    it 'updates current_user rolled state to true and redirects to easter egg' do
      expect(user.rolled).to be_falsey
      request_easter_egg
      user.reload
      expect(user.rolled).to be_truthy
      should redirect_to 'https://youtu.be/eBGIQ7ZuuiU?t=43'
    end
  end
end
