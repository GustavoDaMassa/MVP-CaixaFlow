module ApplicationHelper
  def active_nav_class(path_key)
    current = controller_path
    current.start_with?(path_key) ? "active" : nil
  end
end
