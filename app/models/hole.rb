class Hole < ActiveRecord::Base

  belongs_to :tee
  has_many :scores

  scope :tour_part_hole_avg, -> (id) {
    select("holes.*, ROUND(SUM(s.score)/COUNT(s.id), 2) as avg").
    joins("INNER JOIN scores s on holes.id = s.hole_id").
    where("s.tour_part_id = #{id}").
    group("holes.number")
  }

  scope :competition_hole_avg, -> (id) {
    select("holes.*, ROUND(SUM(s.score)/COUNT(s.id), 2) as avg").
    joins("INNER JOIN scores s on holes.id = s.hole_id").
    where("s.competition_id = #{id}").
    group("holes.number")
  }

  scope :hole_stats, -> (id) {
    select("holes.*").
    where("holes.id = #{id}")
  }

end
