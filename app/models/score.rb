class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :round
  belongs_to :hole
  belongs_to :tee
  belongs_to :competition

  scope :stats_tour_part, -> (id) {
    select("scores.*, COUNT(scores.id) as amount, SUM(scores.score) as total").
    where("tour_part_id = #{id}").
    group("hole_id")
  }

  scope :stats_competition, -> (id, tee) {
    select("scores.*, COUNT(scores.id) as amount, SUM(scores.score) as total").
    where("competition_id = #{id} AND tee_id = #{tee}").
    group("hole_id")
  }

end
