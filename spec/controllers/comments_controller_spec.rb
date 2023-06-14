require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user)           { create(:user) }
  let(:sample_post)    { create(:post) }

  before { sign_in user }

  it { should use_before_action(:set_post_comments) }

  describe 'set_post_comments' do
    before do
      create_list(:comment, 3, post: sample_post)
      request
    end

    context 'when routed through #index' do
      let(:request_params) { { post_id: sample_post.id } }
      let(:request)        { get :index, params: request_params }

      it 'assigns the commented post to @post' do
        expect(assigns(:post)).to eq(sample_post)
      end

      it "assigns the post's comments to @comments" do
        expect(assigns(:comments)).to eq(sample_post.comments)
      end
    end

    context 'when routed through #create' do
      let(:request_params) do
        { post_id: sample_post.id,
          comment: attributes_for(:comment, post_id: sample_post.id) }
      end
      let(:request) { post :create, params: request_params }

      it 'assigns the commented post to @post' do
        expect(assigns(:post)).to eq(sample_post)
      end

      it "assigns the post's comments to @comments" do
        expect(assigns(:comments)).to eq(sample_post.comments)
      end
    end
  end

  describe 'comment_params' do
    context 'when new comment is being created' do
      let(:request_params) do
        { post_id: sample_post.id,
          comment: attributes_for(:comment, post_id: sample_post.id) }
      end

      it { should permit(:post_id, :text).for(:create, params: request_params) }
    end
  end

  describe 'GET #index' do
    let(:request_params) { { post_id: sample_post.id } }
    let(:request)        { get :index, params: request_params }
    let(:comment)        { build(:comment, user:, post: sample_post, text: nil) }
    let(:comments)       { create_list(:comment, 3, post: sample_post)}

    it do
      should receive(:set_post_comments)
      request
    end

    it 'loads comments in ascending order (from old to new)' do
      comments
      request
      expect(assigns(:comments)[0].created_at < assigns(:comments)[1].created_at).to be_truthy
      expect(assigns(:comments)[1].created_at < assigns(:comments)[2].created_at).to be_truthy
    end

    it 'initiates empty Comment instance for form and assigns it to @new_comment' do
      request
      expect(assigns(:new_comment).attributes).to eq(comment.attributes)
    end

    it do
      request
      should render_template(:index)
    end
  end

  describe 'POST #create' do
    let(:comment_attributes) { attributes_for(:comment, post_id: sample_post.id) }
    let(:request_params)     { { post_id: sample_post.id, comment: comment_attributes } }
    let(:request)            { post :create, params: request_params }

    context 'with valid attributes' do
      it 'creates a new comment record' do
        expect { request }.to change(Comment, :count).by(1)
      end

      it "creates only current user's comment and sets current user id for Comment instance" do
        request
        expect(assigns(:new_comment).user_id).to eq(user.id)
        expect(assigns(:new_comment).user_id).not_to eq(sample_post.user_id)
      end

      it "sets commented post's id to Comment instance" do
        request
        expect(assigns(:new_comment).post_id).to eq(sample_post.id)
      end

      it do
        request
        should redirect_to(post_comments_path(sample_post))
      end

      it 'sets a flash notice' do
        request
        expect(flash[:notice]).to eq('You commented the post.')
      end
    end

    context 'with invalid attributes' do
      shared_examples 'an invalid comment' do
        it 'does not create a new comment record' do
          expect { request }.to_not change(Comment, :count)
        end

        it 'renders index template with new_comment form with unprocessable_entity status' do
          expect(request).to render_template(:index)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'keeps the input text data' do
          request
          expect(assigns(:new_comment).text).to eq(comment_attributes[:text].to_s)
        end
      end

      context 'too long text' do
        let(:comment_attributes) { attributes_for(:comment, :with_too_long_text) }

        it_behaves_like 'an invalid comment'

        it 'adds error' do
          request
          expect(assigns(:new_comment).errors.inspect)
            .to include('#<ActiveModel::Error attribute=text, type=too_long, options={:count=>2200}>')
        end
      end

      context 'no text' do
        let(:comment_attributes) { attributes_for(:comment, text: nil) }

        it_behaves_like 'an invalid comment'

        it 'adds error' do
          request
          expect(assigns(:new_comment).errors.inspect)
            .to include('#<ActiveModel::Error attribute=text, type=blank, options={}>')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:request_params)  { { post_id: sample_post.id, id: comment.id } }
    let(:request)         { delete :destroy, params: request_params }

    before { comment }

    shared_examples 'a successful deletion action' do
      it 'destroys the comment record' do
        expect { request }.to change(Comment, :count).by(-1)
      end

      it "redirects to post's comments" do
        expect(request).to redirect_to post_comments_url(sample_post)
      end

      it 'flashes notice of successful deletion' do
        request
        expect(flash[:notice]).to eq('Comment was deleted.')
      end
    end

    context "user's own comment under other user's post" do
      let(:comment) { create(:comment, user:, post: sample_post) }

      it_behaves_like 'a successful deletion action'
    end

    context "other user's comment under own post" do
      let(:sample_post) { create :post, user: }
      let(:comment)     { create :comment, post: sample_post }

      it_behaves_like 'a successful deletion action'
    end

    context "other user's comment under other user's post" do
      let(:sample_post) { create :post }
      let(:comment)     { create :comment, post: sample_post }

      it 'does not destroy the comment record' do
        expect { request }.to_not change(Comment, :count)
      end

      it "redirects to post's comments" do
        expect(request).to redirect_to post_comments_url(sample_post)
      end

      it 'flashes notice of failed deletion' do
        request
        expect(flash[:notice]).to eq("You can't delete this comment!")
      end
    end
  end
end
