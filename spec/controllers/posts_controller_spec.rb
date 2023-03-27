require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  it { should use_before_action(:set_post) }

  describe 'set_post' do
    let(:sample_post) { create(:post, user:) }

    it 'assigns the requested post to @post' do
      get :show, params: { user_id: user.id, id: sample_post.id }
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
    context 'user has no posts' do
      it 'assigns nil posts' do
        get :index, params: { user_id: user.id }
        expect(assigns(:@posts)).to be_nil
      end
    end

    context 'user has posts' do
      it "assigns user's posts" do
        create_list(:post, 3, user: user)
        get :index, params: { user_id: user.id }
        expect(assigns(:posts)).to eq(user.posts)
      end
    end

    it 'renders index template' do
      get :index, params: { user_id: user.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:sample_post) { create(:post, user: user) }

    it "assigns user's post" do
      get :show, params: { user_id: user.id, id: sample_post.id }
      expect(assigns(:post)).to eq(sample_post)
    end

    it 'renders show template' do
      get :show, params: { user_id: user.id, id: sample_post.id }
      expect(response).to render_template(:show)
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

      it 'redirects to user posts' do
        expect(request).to redirect_to user_posts_url(user.id)
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
end
