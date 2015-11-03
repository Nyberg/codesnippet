class Tee < ActiveRecord::Base

  belongs_to :course
  has_many :holes
  has_many :tour_parts
  has_many :rounds
  has_many :scores

  scope :get_course_data, -> (id){
    select("tees.id, h.number, h.length, h.par, s.result, SUM(s.score) as total, COUNT(s.score) as sum").
    joins("INNER JOIN holes h on h.tee_id = tees.id").
    joins("INNER JOIN scores s on s.hole_id = h.id").
    where("h.id = #{id}").
    group("s.result, s.hole_id").
    order("tees.id, h.number")
  }

end
