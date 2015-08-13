class Tee < ActiveRecord::Base

  belongs_to :course
  has_many :holes
  has_many :tour_parts
  has_many :rounds
  has_many :scores

end
