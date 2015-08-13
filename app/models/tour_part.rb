class TourPart < ActiveRecord::Base

  belongs_to :competition
  belongs_to :course
  belongs_to :tee
  has_many :rounds

end
