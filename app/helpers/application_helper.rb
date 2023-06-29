module ApplicationHelper
  def tag_nav_link(text, path)
    link_classes = 'nav-link'
    link_classes += ' active bold' if current_page?(path)
    tag.li(link_to(text, path, class: link_classes), class: 'nav-item')
  end
end
