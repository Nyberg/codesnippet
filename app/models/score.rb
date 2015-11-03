class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :round
  belongs_to :hole
  belongs_to :tee
  belongs_to :competition

  scope :stats_tour_part, -> (id) {
    # select("scores.*, COUNT(scores.id) as amount, SUM(scores.score) as total").
    # where("tour_part_id = #{id}").
    # group("hole_id")
  }

  scope :hole_stats, -> (id) {
    # select("h.number, h.par, h.length, COUNT(scores.result) as totals, SUM(score) as sum").
    # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'ace'").
    # #select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'eagle', as eagle").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'birdie' as birdie").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'par' as par").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'bogey' as bogey").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'dblbogey' as dblbogey").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'trpbogey' as trpbogey").
    # # select("COUNT(scores.result) FROM scores WHERE scores.hole_id = 1 and scores.result = 'other' as other").
    # joins("INNER JOIN holes h on h.id = scores.hole_id").
    # where("h.id = #{id}")
  }

  scope :stats_competition, -> (id, tee) {
    select("scores.*, COUNT(scores.id) as amount, SUM(scores.score) as total").
    where("competition_id = #{id} AND tee_id = #{tee}").
    group("hole_id")
  }

end
