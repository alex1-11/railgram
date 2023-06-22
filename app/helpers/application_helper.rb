module ApplicationHelper
  def tag_nav_link(text, path, options = {})
    tag.li(link_to(text, path, options.merge(class: 'nav-link')), class: 'nav-item')
  end
end
