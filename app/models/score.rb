class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :round
  belongs_to :hole
  belongs_to :tee
  belongs_to :competition

  scope :tour_part_avg, -> (id) {
    select("scores.hole_id, ROUND(SUM(scores.score), 2) as sum, COUNT(scores.id) as number").
    where("tour_part_id = #{id}").
    group("scores.hole_id").
    order("scores.hole_id")
  }

  scope :competition_avg, -> (id, tee) {
    select("scores.hole_id, ROUND(SUM(scores.score), 2) as sum, COUNT(scores.id) as number").
    where("competition_id = #{id} AND tee_id = #{tee}").
    group("scores.hole_id").
    order("scores.hole_id")
  }


  scope :stats_competition, -> (id, tee) {
    select("scores.*, COUNT(scores.id) as amount, SUM(scores.score) as total").
    where("competition_id = #{id} AND tee_id = #{tee}").
    group("hole_id")
  }

end
