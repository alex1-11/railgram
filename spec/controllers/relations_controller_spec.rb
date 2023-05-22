require 'rails_helper'

RSpec.describe RelationsController, type: :controller do
  let(:user)     { create :user }
  let(:blogger)  { create :user }

  before { sign_in user }

  it { should use_before_action(:set_user) }

  describe 'POST #create' do
    let(:sample_params) { { followed_id: blogger.id } }
    let(:request)         { post :create, params: sample_params }

    it { should permit(:followed_id).for(:create, params: sample_params) }

    it 'assigns followed_id to instance variable @user' do
      request
      expect(assigns(:user)).to eq(blogger)
    end

    context 'with valid parameters' do
      it 'creates a new relation record' do
        expect { request }.to change(Relation, :count).by(1)
      end

      it 'assigns relation to instance variable @relation' do
        expect(assigns(:relation)).to eq(Relation.find_by(follower: user, followed: blogger))
      end

      it do
        should receive(:replace_follow_elements)
        request
      end

      it 'replaces turbo-frames via turbo-stream' do
        request
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include(
          '<turbo-stream action="replace"',
          'target="followers_counter">',
          'target="follow_toggle">'
        )
      end
    end

    context 'double following' do
      before { user.follow(blogger) }

      it 'does not create new relation record' do
        expect { request }.not_to change(Relation, :count)
      end
    end

    context 'forging other user to follow third user' do
      let(:other_user)    { create :user }
      let(:sample_params) { { follower_id: other_user.id, followed_id: blogger.id } }

      it 'creates a new relation record, but for the deceitful user instead' do
        expect { request }.to change(Relation, :count).by(1)
        expect(assigns(:relation).follower).to eq(user)
        expect(assigns(:relation).follower).not_to eq(other_user)
      end
    end

    context 'forging other user to follow current user' do
      let(:other_user)    { create :user }
      let(:sample_params) { { follower_id: other_user.id, followed_id: user.id } }

      it 'does not create new relation record' do
        expect { request }.not_to change(Relation, :count)
      end
    end

    context 'self following' do
      let(:sample_params) { { followed_id: user.id } }

      it 'does not create new relation record' do
        expect { request }.not_to change(Relation, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:relation)       { create(:relation, follower: user, followed: blogger) }
    let(:sample_params)  { { followed_id: blogger.id, id: relation.id } }
    let(:request)        { delete :destroy, params: sample_params }

    before { relation }

    it { should permit(:followed_id, :id).for(:destroy, params: sample_params, verb: :delete) }

    it 'assigns followed_id to instance variable @user' do
      request
      expect(assigns(:user)).to eq(blogger)
    end

    context 'with valid parameters' do
      it 'destroys the relation record' do
        expect { request }.to change(Relation, :count).by(-1)
      end

      it do
        should receive(:replace_follow_elements)
        request
      end

      it 'replaces turbo-frames via turbo-stream' do
        request
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
        expect(response).to render_template(layout: false)
        expect(response.body).to include(
          '<turbo-stream action="replace"',
          'target="followers_counter">',
          'target="follow_toggle">'
        )
      end
    end

    context 'nonexistent relation' do
      before { user.unfollow(blogger) }

      it 'does not change any relation record' do
        expect { request }.not_to change(Relation, :count)
      end
    end

    context 'forging other user to unfollow third user' do
      let(:other_user)    { create :user }
      let(:relation)      { create :relation, follower: other_user, followed: blogger }
      let(:sample_params) { { follower_id: other_user.id, followed_id: blogger.id, id: relation } }

      it 'does not affect relations' do
        expect { request }.not_to change(Relation, :count)
        expect(other_user.follows?(blogger)).to be_truthy
      end

      context 'if deceitful user also follows the third user' do
        before { user.follow(blogger) }

        it 'makes deceitful user to unfollow the third user instead' do
          expect { request }.to change(Relation, :count).by(-1)
          expect(other_user.follows?(blogger)).to be_truthy
          expect(user.follows?(blogger)).to be_falsey
        end
      end
    end

    context 'forging other user to unfollow current user' do
      let(:other_user)    { create :user }
      let(:relation)      { create :relation, follower: other_user, followed: user }
      let(:sample_params) { { follower_id: other_user.id, followed_id: user.id, id: relation } }

      it 'does not affect relations' do
        expect { request }.not_to change(Relation, :count)
        expect(other_user.follows?(user)).to be_truthy
      end
    end
  end
end
