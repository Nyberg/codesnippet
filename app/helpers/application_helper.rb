module ApplicationHelper

  def authorize
    return true if logged_in?
  end

  def admin?
    return true if current_user.admin == 1
  end

  def load_navbar
    begin
      render :partial => @navbar || "#{params[:controller]}/partials/navbar.show" unless params[:action] == "index"
    rescue ActionView::MissingTemplate
    end
  end

  def get_ob_stroke(ob)
    return "ob" if ob == 1
  end

  def calc_score(score, par)
    return "#{score} (#{score - par})"
  end

  def calc_total_score(score, players, par)
    data = score/players
    return "#{data} (#{data - par})"
  end

  def calc_to_par(score, par)
    return score - par
  end

  def get_score(score, par)

    if par == 3
      return "ace" if score == 1
      return "birdie" if score == 2
      return "par"  if score == 3
      return "bogey" if score == 4
      return "dblbogey" if score == 5
      return "tplbogey" if score == 6
      return "other" if score >= 7
    elsif par == 4
      return "ace" if score == 1
      return "eagle" if score == 2
      return "birdie" if score == 3
      return "par"  if score == 4
      return "bogey" if score == 5
      return "dblbogey" if score == 6
      return "tplbogey" if score == 7
      return "other" if score >= 8
    elsif par == 5
      return "ace" if score == 1
      return "albatross" if score == 2
      return "eagle" if score == 3
      return "birdie" if score == 4
      return "par"  if score == 5
      return "bogey" if score == 6
      return "dblbogey" if score == 7
      return "tplbogey" if score == 8
      return "quadbogey" if score == 9
      return "other" if score >= 10
    end
  end

  def get_result_id(score, par)

    if par == 3
      return 1 if score == 1
      return 3 if score == 2
      return 4  if score == 3
      return 5 if score == 4
      return 6 if score == 5
      return 7 if score == 6
      return 8 if score >= 7
    elsif par == 4
      return 1 if score == 1
      return 2 if score == 2
      return 3 if score == 3
      return 4  if score == 4
      return 5 if score == 5
      return 6 if score == 6
      return 7 if score == 7
      return 8 if score == 8
    elsif par == 5
      return "ace" if score == 1
      return "albatross" if score == 2
      return "eagle" if score == 3
      return "birdie" if score == 4
      return "par"  if score == 5
      return "bogey" if score == 6
      return "dblbogey" if score == 7
      return "tplbogey" if score == 8
      return "quadbogey" if score == 9
      return "other" if score >= 10
    end
  end

end
