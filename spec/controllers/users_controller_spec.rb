require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user)    { create :user }
  let(:prepare) {}
  let(:request) {}

  before do
    sign_in user
    prepare
    request
  end

  it { should use_before_action(:set_user) }

  describe 'GET #index' do
    let(:users)       { create_list :user, 50, followers_count: 3 }
    let(:spare_users) { create_list :user, 2 }
    let(:request)     { get :index }

    it 'assigns 50 top followed users' do
      expect(assigns(:users)).to match_array(users)
      expect(assigns(:users)).to_not include(spare_users[0])
      expect(assigns(:users)).to_not include(spare_users[1])
    end

    context 'users have different number of followers' do
      let(:popular_user) { create :user, followers_count: 500 }
      let(:regular_user) { create :user, followers_count: 30 }
      let(:fresh_user)   { create :user, followers_count: 5 }
      let(:prepare) do
        popular_user
        regular_user
        fresh_user
      end

      it 'puts users in descending order by number of followers' do
        expect(assigns(:users)[0]).to eq(popular_user)
        expect(assigns(:users)[1]).to eq(regular_user)
        expect(assigns(:users)[2]).to eq(fresh_user)
      end
    end
  end

  describe 'GET #show' do
    let(:request) { get :show, params: { id: user.id } }

    it { should permit(:id).for(:show, params: { id: user.id }, verb: :get) }

    context 'signed in user trying to view his/her own user page' do
      before { create_list(:post, 3, user:) }

      it 'assigns user and posts instance variables with user from request' do
        expect(assigns(:user)).to eq(user)
        expect(assigns(:posts)).to match_array(user.posts)
      end

      it 'assigns posts in descending order of creation datetime' do
        expect(assigns(:posts)[0].created_at > assigns(:posts)[1].created_at).to be_truthy
        expect(assigns(:posts)[1].created_at > assigns(:posts)[2].created_at).to be_truthy
      end

      it { should permit(:id).for(:show, verb: :get, params: { id: user.id }) }
      it { should render_template(:show) }
    end

    context 'trying to view other user page' do
      let(:other_user) { create :user }
      let(:request)    { get :show, params: { id: other_user.id } }

      before { create_list(:post, 3, user: other_user) }

      it 'assigns user and posts instance variables with user from request' do
        expect(assigns(:user)).to eq(other_user)
        expect(assigns(:posts)).to match_array(other_user.posts)
      end

      it 'assigns posts in descending order of creation datetime' do
        expect(assigns(:posts)[0].created_at > assigns(:posts)[1].created_at).to be_truthy
        expect(assigns(:posts)[1].created_at > assigns(:posts)[2].created_at).to be_truthy
      end

      it { should permit(:id).for(:show, verb: :get, params: { id: other_user.id }) }
      it { should render_template(:show) }
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

  describe 'GET #followers' do
    let(:other_user) { create :user }
    let(:request)    { get :followers, params: { id: other_user.id } }

    before do
      create_list(:relation, 3, followed: other_user)
      request
    end

    it { should permit(:id).for(:followers, params: { id: other_user.id }, verb: :get) }

    it 'assigns user instance variable with user from request' do
      expect(assigns(:user)).to eq(other_user)
    end

    it 'assigns user followers to @followers' do
      expect(assigns(:followers)).to match_array(other_user.followers)
    end

    it { should render_template(:followers) }
  end

  describe 'GET #following' do
    let(:other_user) { create :user }
    let(:request)    { get :following, params: { id: other_user.id } }

    before do
      create_list(:relation, 3, follower: other_user)
      request
    end

    it { should permit(:id).for(:following, params: { id: other_user.id }, verb: :get) }

    it 'assigns user instance variable with user from request' do
      expect(assigns(:user)).to eq(other_user)
    end

    it 'assigns user following to @following' do
      expect(assigns(:following)).to match_array(other_user.following)
    end

    it { should render_template(:following) }
  end

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

  describe 'GET #edit_avatar' do
    let(:request) { get :edit_avatar }

    it { should render_template(:edit_avatar) }
  end

  describe 'PATCH #set_avatar' do
    let(:request_params) { { user: attributes_for(:user, :simulate_avatar_form_upload) } }
    let(:request)        { patch :set_avatar, params: request_params }

    it { should permit(:avatar).for(:set_avatar, verb: :patch, params: request_params) }

    context 'valid avatar file uploaded' do
      it 'updates the user avatar' do
        user.reload
        expect(user.avatar).to be_present
        expect(user.avatar_data).to be_present
        expect(user.avatar.original_filename).to eq(request_params[:user][:avatar].original_filename)
      end

      it 'redirects to edit avatar page' do
        expect(response).to redirect_to(edit_avatar_path)
      end
    end

    context 'avatar file with wrong extension was uploaded' do
      let(:request_params) { { user: attributes_for(:user, :uploades_avatar_with_wrong_ext) } }

      it 'rerenders edit_avatar template with form with unprocessable_entity status' do
        expect(request).to render_template(:edit_avatar)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'adds error' do
        viewer = controller.instance_variable_get(:@viewer)
        expect(viewer).to eq(user)
        expect(viewer.errors.inspect)
          .to include('#<ActiveModel::Errors [#<ActiveModel::Error attribute=avatar, type=extension must be one of: jpg, jpeg, png, webp, options={}>]>')
      end
    end
  end

  describe 'PATCH #remove_avatar' do
    let(:user)                  { create :user, :with_avatar }
    let(:request_remove_avatar) { patch :remove_avatar }

    it 'removes current avatar for logged in user' do
      expect(user.avatar).to_not be_nil
      request_remove_avatar
      user.reload
      expect(user.avatar).to be_nil
    end

    it 'redirects to edit avatar path' do
      request_remove_avatar
      should redirect_to edit_avatar_path
    end

    context 'avatar is already absent' do
      let(:user) { create :user }

      before { request_remove_avatar }

      it { should render_template :edit_avatar }
    end
  end
end
