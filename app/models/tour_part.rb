class TourPart < ActiveRecord::Base

  belongs_to :competition
  belongs_to :course
  belongs_to :tee
  has_many :rounds, dependent: :destroy

  scope :search, -> (term) {
    joins("INNER JOIN courses c on tour_parts.course_id = c.id").
    joins("INNER JOIN competitions co on tour_parts.competition_id = co.id").
    joins("INNER JOIN clubs cl on co.club_id = cl.id").
    where("c.name LIKE ? or tour_parts.name LIKE ? or co.name LIKE ? or cl.name LIKE ?", *(["%#{term}%"]*4))
  }
  scope :by_name, -> { order(name: :asc) }
  scope :by_date, -> { order(date: :desc) }
  scope :group_by_month, -> (id, competition_id) {
    select("date, MONTH(tour_parts.date) as month").
    where("competition_id = #{competition_id}").
    group("month").
    order("month DESC")
  }
  scope :by_competition_and_date, -> (id, tour_date){
    select("id, name, date").
    where("competition_id = #{id} and MONTH(date) = #{tour_date}").
    order("date DESC")
  }
end
