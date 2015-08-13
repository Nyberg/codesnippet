class Round < ActiveRecord::Base

  belongs_to :user
  belongs_to :course
  belongs_to :tour_part
  belongs_to :tee
  has_many :scores

end
