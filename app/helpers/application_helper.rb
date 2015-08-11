module ApplicationHelper

  def authorize
    return true if logged_in?
  end

end
