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
  scope :bogeyfree_rounds, -> (id) {
    select("rounds.*, GROUP_CONCAT(s.result SEPARATOR ',') as result").
    joins("INNER JOIN scores s on s.round_id = rounds.id").
    where("rounds.competition_id = #{id}").
    group("rounds.id")
  }

  scope :competition_players, -> (id) {
    select("u.name, COUNT(rounds.id) as rounds_count, c.name as club_name").
    joins("INNER JOIN users u on rounds.user_id = u.id").
    joins("INNER JOIN clubs c on u.club_id = c.id").
    where("rounds.competition_id = #{id}").
    group("u.id").
    order("u.name")
  }

  after_create :build_scores

 def build_scores
   self.tee.holes.each do |h|
     Score.create(round: self, hole_id: h.id, tee_id: h.tee_id, user_id: self.user_id, score: h.par, tour_part_id: self.tour_part_id, competition_id: self.competition_id) # Associations must be defined correctly for this syntax, avoids using ID's directly.
   end
 end

end
