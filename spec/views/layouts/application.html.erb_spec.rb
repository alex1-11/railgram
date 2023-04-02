require 'rails_helper'

RSpec.describe 'layouts/application', type: :view do
  let(:notice) { 'This is a notice message' }
  let(:alert)  { 'This is an alert message' }

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
