class Score < ActiveRecord::Base

  belongs_to :user
  belongs_to :round
  belongs_to :hole
  belongs_to :tee

end
