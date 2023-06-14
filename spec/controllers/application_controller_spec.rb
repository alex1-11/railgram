require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'hello world'
    end
  end

  describe 'before actions' do
    describe 'set_viewer' do
      let(:user) { create :user }

      before do
        sign_in user
        get :index
      end

      it { should use_before_action(:set_viewer) }

      it 'gets current_user and assigns it to @viewer' do
        get :index
        expect(assigns(:viewer)).to eq(user)
      end
    end

    context 'when not on home controller' do
      before { allow(controller).to receive(:home_controller?).and_return(false) }

      it 'authenticates the user' do
        expect(controller).to receive(:authenticate_user!)
        get :index
      end
    end

    context 'when on home controller' do
      before { allow(controller).to receive(:home_controller?).and_return(true) }

      it 'does not authenticate the user' do
        expect(controller).not_to receive(:authenticate_user!)
        get :index
      end
    end

    context 'when on a devise controller' do
      before { allow(controller).to receive(:devise_controller?).and_return(true) }

      it 'configures permitted parameters' do
        expect(controller).to receive(:configure_permitted_parameters)
        get :index
      end
    end

    context 'when not on a devise controller' do
      before { allow(controller).to receive(:devise_controller?).and_return(false) }

      it 'does not configure permitted parameters' do
        expect(controller).not_to receive(:configure_permitted_parameters)
        get :index
      end
    end
  end

  describe '#home_controller?' do
    context "when params[:controller] is 'home'" do
      before { allow(controller.params).to receive(:[]).with(:controller).and_return('home') }

      it 'returns true' do
        expect(controller.send(:home_controller?)).to be_truthy
      end
    end

    context "when params[:controller] is not 'home'" do
      before { allow(controller.params).to receive(:[]).with(:controller).and_return('users') }

      it 'returns false' do
        expect(controller.send(:home_controller?)).to be_falsey
      end
    end
  end
end
