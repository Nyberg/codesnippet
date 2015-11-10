class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :round
  belongs_to :hole
  belongs_to :tee
  belongs_to :competition
  #belongs_to :result

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
  # scope :hole_results, -> (tour_part, hole_id) {
  #   select("scores.result, COUNT(scores.result) as sum").
  #   where("tour_part_id = #{tour_part} AND hole_id = #{hole_id}").
  #   group("result")
  # }

  scope :get_type, -> (id, tour_part, type){
    select("COUNT(scores.id) as sum").
    where("scores.hole_id = #{id} and scores.tour_part_id = #{tour_part} and scores.result_type = '#{type}'")
  }

  scope :hole_results, -> (tour_part_id, tee_id, result) {
    select("COUNT(scores.result_type) as sum").
    where("tour_part_id = #{tour_part_id} AND tee_id = #{tee_id} AND scores.result_type = '#{result}'").
    group("scores.hole_id")
  }

end
