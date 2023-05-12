require 'rails_helper'

RSpec.describe RelationsController, type: :controller do
  let(:user)            { create :user }
  let(:blogger)         { create :user }
  let(:relation) { build(:relation, follower: user, followed: blogger) }

  before { sign_in user }

  describe 'relation_params' do
    context 'when new relation is being created' do
      # FIXME: continue from here
      let(:sample_params) { { followed_id: blogger.id } }

      it { should permit(:followed_id).for(:create, params: sample_params) }
    end

    context 'when existing relation is being destroyed' do
      let(:like)          { create(:like, user:, post: sample_post) }
      let(:sample_params) { { post_id: sample_post.id, id: like.id } }

      it { should permit(:post_id, :id).for(:destroy, params: sample_params, verb: :delete) }
    end
  end

  describe 'POST #create' do
    let(:request_params)  { { post_id: sample_post.id } }
    let(:request)         { post :create, params: request_params }

    context 'with valid attributes' do
      it 'creates a new like record' do
        expect { request }.to change(Like, :count).by(1)
      end

      it 'handles only current user likes and sets current user id for Like instance' do
        request
        expect(assigns(:like).user_id).to eq(user.id)
        expect(assigns(:like).user_id).not_to eq(sample_post.user_id)
      end

      it 'sets liked post id to Like instance' do
        request
        expect(assigns(:like).post_id).to eq(sample_post.id)
      end

      it do
        should receive(:update_like_toggle)
        request
      end

      it 'updates turbo-frame via turbo-stream' do
        request
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include('<turbo-stream action="replace"', "target=\"like_toggle_#{sample_post.id}\">")
      end
    end

    context "when trying to forge other user's like" do
      let(:other_user)     { create :user }
      let(:request_params) { { post_id: sample_post.id, user_id: other_user.id } }

      it 'creates a new like record, but for the calling user' do
        expect { request }.to change(Like, :count).by(1)
        expect(assigns(:like).user_id).to eq(user.id)
        expect(assigns(:like).user_id).not_to eq(other_user.id)
      end

      it do
        should receive(:update_like_toggle)
        request
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:like)            { create(:like, user:, post: sample_post) }
    let(:request_params)  { { post_id: sample_post.id, id: like.id } }
    let(:request)         { delete :destroy, params: request_params }

    before { like }

    it 'destroys the like record' do
      expect { request }.to change(Like, :count).by(-1)
    end

    it do
      should receive(:update_like_toggle)
      request
    end

    it 'updates turbo-frame via turbo-stream' do
      request
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq Mime[:turbo_stream]
      expect(response).to render_template(layout: false)
      expect(response.body).to include('<turbo-stream action="replace"', "target=\"like_toggle_#{sample_post.id}\">")
    end
  end
end
