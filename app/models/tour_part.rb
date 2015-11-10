class TourPart < ActiveRecord::Base

  belongs_to :competition
  belongs_to :course
  belongs_to :tee
  has_many :rounds

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
