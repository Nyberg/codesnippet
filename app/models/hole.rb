class Hole < ActiveRecord::Base

  belongs_to :tee
  has_many :scores

end
