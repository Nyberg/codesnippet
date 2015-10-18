class Round < ActiveRecord::Base

  belongs_to :user
  belongs_to :course
  belongs_to :tour_part
  belongs_to :competition
  belongs_to :tee
  has_many :scores, dependent: :destroy
  has_many :holes, through: :scores

  default_scope { order(total: :asc)}
  #scope :by_date, -> {order(created_at: :asc)}
  scope :holes, -> (tee) { joins(:holes).where("holes.tee_id = #{tee}") }

  after_create :build_scores

 def build_scores
   #raise self.tee.holes.inspect
   self.tee.holes.each do |h|
     Score.create(round: self, hole_id: h.id, tee_id: h.tee_id, user_id: self.user_id, score: h.par) # Associations must be defined correctly for this syntax, avoids using ID's directly.
   end
 end

end
