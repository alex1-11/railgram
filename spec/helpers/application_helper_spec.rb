require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#tag_nav_link' do
    let(:path) { '/path' }

    context 'when current page matches the provided path' do
      before do
        allow(helper).to receive(:current_page?).with(path).and_return(true)
      end

      it 'renders a nav link with active class' do
        expect(helper.tag_nav_link('Link Text', path)).to have_css('li.nav-item')
        expect(helper.tag_nav_link('Link Text', path)).to have_css('a.nav-link.active', text: 'Link Text')
      end
    end

    context 'when current page does not match the provided path' do
      before do
        allow(helper).to receive(:current_page?).with(path).and_return(false)
      end

      it 'renders a nav link without active class' do
        expect(helper.tag_nav_link('Link Text', path)).to have_css('li.nav-item')
        expect(helper.tag_nav_link('Link Text', path)).to have_css('a.nav-link', text: 'Link Text')
        expect(helper.tag_nav_link('Link Text', path)).not_to have_css('a.nav-link.active')
      end
    end
  end
end
