module ApplicationHelper

  def authorize
    return true if logged_in?
  end

  def get_ob_stroke(ob)
    return "ob" if ob == 1
  end

  def calc_score(score, par)
    return "#{score} (#{score - par})"
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
      return "quadbogey" if score == 7
      return "other" if score >= 8
    elsif par == 4
      return "ace" if score == 1
      return "eagle" if score == 2
      return "birdie" if score == 3
      return "par"  if score == 4
      return "bogey" if score == 5
      return "dblbogey" if score == 6
      return "tplbogey" if score == 7
      return "quadbogey" if score == 8
      return "other" if score >= 9
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
