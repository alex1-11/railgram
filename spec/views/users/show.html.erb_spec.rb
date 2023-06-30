require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user)  { create(:user) }
  let(:posts) { create_list(:post, 3, user:) }

  before do
    assign(:user, user)
    assign(:viewer, user)
    assign(:posts, posts)
    render
  end

  it { should render_template(partial: 'users/profile', count: 1, locals: { user: }) }

  it 'renders the users/show view' do
    expect(rendered).to have_selector('.bg-secondary-subtle') do |container|
      expect(container).to have_rendered_partial('users/profile').once
      expect(container).to have_selector('.post-thumbnails.container.text-center') do |thumbnails|
        expect(thumbnails).to have_selector('.row.row-cols-auto.g-0.justify-content-center') do |row|
          expect(row).to have_selector('a.col.align-self-center', count: 3) do |links|
            posts.each do |post|
              expect(links).to have_selector("img[src='#{post.image_url(:thumbnail)}'].img-fluid.mx-auto.d-block.object-fit-fill")
              expect(links).to have_link(href: "#{user_posts_path(user)}##{dom_id(post)}")
            end
          end
        end
      end
    end
  end
end
