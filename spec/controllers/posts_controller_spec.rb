require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create :user }

  before { sign_in user }

  it { should use_before_action(:set_post) }

  describe 'set_post' do
    let(:sample_post) { create(:post, user:) }

    it 'assigns the requested post to @post' do
      get :edit, params: { user_id: user.id, id: sample_post.id }
      expect(assigns(:post)).to eq(sample_post)
    end
  end

  describe 'post_params' do
    # Tested via shoulda_matchers gem (more about matcher `permit`: https://github.com/thoughtbot/shoulda-matchers/blob/main/lib/shoulda/matchers/action_controller/permit_matcher.rb)
    let(:sample_params) do
      { user_id: user.id,
        post: attributes_for(:post, :simulate_form_upload, user:) }
    end

    it do
      should permit(:image, :caption, :user_id)
        .for(:create, params: sample_params)
    end
  end

  describe 'GET #index' do
    let(:request) { get :index, params: { user_id: user.id } }

    before { request }

    it { should render_template(:index) }

    context 'user has no posts' do
      it 'assigns empty posts collection' do
        expect(assigns(:posts)).to be_empty
      end
    end

    context 'user has some posts' do
      it "assigns user and user's posts" do
        create_list(:post, 3, user:)
        expect(assigns(:user)).to eq(user)
        expect(assigns(:posts)).to match_array(user.posts)
      end

      it 'assigns posts in descending order of creation datetime' do
        create_list(:post, 3, user:)
        expect(assigns(:posts)[0].created_at > assigns(:posts)[1].created_at).to be_truthy
        expect(assigns(:posts)[1].created_at > assigns(:posts)[2].created_at).to be_truthy
      end
    end

    context "user accesses other user's posts" do
      let(:other_user)   { create :user }
      let(:sample_posts) { create_list(:post, 3, user: other_user) }
      let(:request)      { get :index, params: { user_id: other_user.id } }

      it 'assigns other user and his/her posts' do
        expect(assigns(:user)).to eq(other_user)
        expect(assigns(:posts)).to eq(other_user.posts)
      end
    end
  end

  describe 'GET #show' do
    context 'user accesses own post' do
      let(:sample_post) { create(:post, user:) }

      it "assigns user's post" do
        get :show, params: { user_id: user.id, id: sample_post.id }
        expect(assigns(:post)).to eq(sample_post)
      end

      it 'renders show template' do
        get :show, params: { user_id: user.id, id: sample_post.id }
        expect(response).to render_template(:show)
      end
    end

    context "user accesses other user's post" do
      let(:sample_post) { create(:post) }

      it "assigns user's post" do
        get :show, params: { user_id: sample_post.user_id, id: sample_post.id }
        expect(assigns(:post)).to eq(sample_post)
      end

      it 'renders show template' do
        get :show, params: { user_id: sample_post.user_id, id: sample_post.id }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #new' do
    # Initialize new Post instance with current user_id and nil attributes
    let(:sample_post) { Post.new(user_id: user.id) }

    it "initiates post with nil parameters, except current user's user_id" do
      get :new, params: {user_id: user.id }
      expect(assigns(:post).attributes).to eq(sample_post.attributes)
    end

    it "renders 'new' template" do
      get :new, params: { user_id: user.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    # Get post instance with current user_id, post_id
    let(:sample_post) { create(:post, user: user) }

    context 'edit own posts' do
      it "loads and assigns post with user_id and post_id" do
        get :edit, params: { user_id: user.id, id: sample_post.id }
        expect(assigns(:post).attributes).to eq(sample_post.attributes)
      end

      it "renders 'edit' template" do
        get :edit, params: { user_id: user.id, id: sample_post.id }
        expect(response).to render_template(:edit)
      end
    end

    context "edit other user's post" do
      let(:foreign_post) { create(:post) }

      it "raises error and assigns no posts" do
        expect { get :edit, params: { user_id: foreign_post.user_id, id: foreign_post.id } }
          .to raise_error(ActiveRecord::RecordNotFound)
        expect(assigns(:post)).to be_nil
      end
    end
  end

  describe 'POST #create' do
    let(:post_attributes) { attributes_for(:post, :simulate_form_upload, user_id: user.id) }
    let(:request_params)  { { user_id: user.id, post: post_attributes } }
    let(:request)         { post :create, params: request_params }

    context 'with valid attributes' do
      it 'creates a new post record' do
        expect { request }.to change(Post, :count).by(1)
      end

      it "redirects to user's posts" do 
        expect(request).to redirect_to(user_posts_url(user))
      end

      it 'sets a flash notice' do
        request
        expect(flash[:notice]).to eq('Post was successfully created.')
      end
    end

    context 'with invalid attributes' do
      let(:post_attributes) { attributes_for(:post, user_id: user.id, image: nil, image_data: nil) }
      let(:sample_post)     { Post.new(post_attributes) }

      it "doesn't create a new post record" do
        expect { request }.to_not change(Post, :count)
      end

      it 'rerenders form' do
        expect(request).to render_template(:new)
      end

      it 'keeps the input data' do
        request
        expect(assigns(:post).attributes).to include(sample_post.attributes)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    let(:original_post)  { create(:post, user_id: user.id) }
    let(:new_attributes) { attributes_for(:post, :simulate_form_upload, user_id: user.id) }
    let(:updated_post)   { Post.new(new_attributes) }
    let(:request_params) { { user_id: user.id, post: new_attributes, id: original_post.id } }
    let(:request)        { put :update, params: request_params }

    context 'with valid attributes' do
      it 'assigns updated attributes to the post' do
        request
        expect(assigns(:post).caption).to eq(updated_post.caption)
        expect(assigns(:post).image.metadata).to eq(updated_post.image.metadata)
      end

      it 'redirects to updated post' do
        expect(request).to redirect_to post_path(original_post)
      end

      it 'sets a flash notice' do
        request
        expect(flash[:notice]).to eq('Post was successfully updated.')
      end
    end

    context 'with invalid attributes' do
      let(:new_attributes) { attributes_for(:post, :with_too_long_caption_only, user_id: user.id) }

      it "doesn't update the post record" do
        request
        expect(assigns(:post).caption).to_not eq(new_attributes['caption'])
        expect(assigns(:post).image).to_not eq(new_attributes['image'])
      end

      it 'rerenders form' do
        request
        expect(request).to render_template(:edit)
      end

      it 'keeps the input data' do
        request
        expect(assigns(:post).caption).to eq(updated_post.caption)
      end

      it 'adds error' do
        request
        expect(assigns(:post).errors.inspect)
          .to include('#<ActiveModel::Error attribute=caption, type=too_long, options={:count=>2200}>')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:sample_post)    { create(:post, user_id: user.id) }
    let(:request_params) { { user_id: user.id, id: sample_post } }
    let(:request)        { delete :destroy, params: request_params }

    before { sample_post }

    it 'destroys the post record' do
      expect { request }.to change(Post, :count).by(-1)
    end

    it 'redirects to user posts' do
      expect(request).to redirect_to user_posts_url(user.id)
    end

    it 'flashes notice of successful deletion' do
      request
      expect(flash[:notice]).to eq('Post was successfully deleted.')
    end
  end

  # FIXME
  describe 'feed' do
    let(:blogger1)  { create :user }
    let(:blogger2)  { create :user }
    let(:posts1)    { create_list(:post, 3, user: blogger1) }
    let(:posts2)    { create_list(:post, 3, user: blogger2) }
    let(:relation1) { create(:relation, follower: user, followed: blogger1) }
    let(:relation2) { create(:relation, follower: user, followed: blogger2) }
    let(:request)   { get :feed }

    before { request }
    it 'assigns all posts of followed users to @posts instance variable' do
      posts_collection = [posts1, posts2]
      expect(assigns(:posts)).to match_array(posts_collection)
    end
    it 'puts posts at descending order from fresh to old' do

    end
  end
end
