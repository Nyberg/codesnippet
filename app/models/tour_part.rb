class TourPart < ActiveRecord::Base

  belongs_to :competition
  belongs_to :course
  belongs_to :tee
  has_many :rounds

  scope :by_name, -> { order(name: :asc) }
  scope :by_date, -> { order(date: :desc) }
end
