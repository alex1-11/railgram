require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  let(:notice) { 'This is a notice message' }
  let(:alert)  { 'This is an alert message' }

  describe 'basic rendering' do
    before do
      flash[:notice] = notice
      flash[:alert] = alert
      render
    end

    it 'displays the page title' do
      expect(rendered).to have_title('Railgram')
    end

    it 'displays the navbar' do
      expect(rendered).to render_template(partial: 'shared/_navbar')
    end

    it 'displays the notice message if present' do
      expect(rendered).to have_selector('.alert.alert-success', text: notice)
    end

    it 'displays the alert message if present' do
      expect(rendered).to have_selector('.alert.alert-danger', text: alert)
    end

    it 'displays the main content' do
      expect(rendered).to have_selector('body > *:not(header):not(footer)')
    end
  end

  describe 'color theme attribute' do
    it 'renders the body tag with the correct data-bs-theme attribute' do
      allow(view).to receive(:cookies).and_return({ theme: 'dark' })
      render
      expect(rendered).to have_selector("body[data-bs-theme='dark']")
    end

    it 'renders the body tag with the default data-bs-theme attribute when cookies[:theme] is not set' do
      allow(view).to receive(:cookies).and_return({})
      render
      expect(rendered).to have_selector("body[data-bs-theme='light']")
    end
  end
end
