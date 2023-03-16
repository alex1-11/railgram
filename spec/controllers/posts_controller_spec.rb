require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  before { sign_in user }

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
    let(:post) { create(:post, user: user) }

    it "assigns user's post" do
      get :show, params: { user_id: user.id, id: post.id }
      expect(assigns(:post)).to eq(post)
    end

    it 'renders show template' do
      get :show, params: { user_id: user.id, id: post.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    # Initialize new Post instance with current user_id and nil attributes
    let(:post) { Post.new(user_id: user.id) }

    it "initiates post with nil parameters, except current user's user_id" do
      get :new, params: {user_id: user.id }
      expect(assigns(:post).attributes).to eq(post.attributes)
    end

    it "renders 'new' template" do
      get :new, params: { user_id: user.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    # Get post instance with current user_id, post_id
    let(:post) { create(:post, user: user) }

    context 'edit own posts' do
      it "loads and assigns post with user_id and post_id" do
        get :edit, params: { user_id: user.id, id: post.id }
        expect(assigns(:post).attributes).to eq(post.attributes)
      end

      it "renders 'edit' template" do
        get :edit, params: { user_id: user.id, id: post.id }
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

  # TODO
  describe 'POST #create' do
    let(:post_attributes) { attributes_for(:post, user_id: user.id) }
    let(:request_params) do
      { user_id: user.id,
        post: post_attributes }
    end

    context 'with valid attributes' do
      it 'creates a new post record' do
        expect { post :create, params: request_params }.to change(Post, :count).by(1)
      end

      it 'redirects to user_posts_url' do
        # TODO: expect { post :create, params: request_params }.to redirect_to(user_posts_url())
        # }
      end
    end


  end
end
