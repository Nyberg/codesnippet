class Round < ActiveRecord::Base

  belongs_to :user
  belongs_to :course
  belongs_to :tour_part
  belongs_to :competition
  belongs_to :tee
  has_many :scores, dependent: :destroy
  has_many :holes, through: :scores

  default_scope { order(total: :asc)}
  scope :holes, -> (tee) { joins(:holes).where("holes.tee_id = #{tee}") }
  scope :bogeyfree_rounds, -> {
    select("rounds.*, GROUP_CONCAT(s.result_id SEPARATOR ',') as result_type").
    joins("INNER JOIN scores s on s.round_id = rounds.id") }

  # These 4 scopes are used for bogeyfree_rounds
  scope :group_by_round, -> { group("rounds.id") }
  scope :from_competition, -> (id) { where("rounds.competition_id = ?", id) }
  scope :from_tour_part, -> (id) { where("rounds.tour_part_id = ?", id) }
  scope :by_user, -> (user_id){ where("rounds.user_id = ?", user_id) }

  # This scope gets all rounds with score lower than par
  scope :below_par, -> {
    select("COUNT(rounds.id) as sum").
    joins("INNER JOIN tees t on rounds.tee_id = t.id").
    where("rounds.total < t.par")
  }

  scope :competition_players, -> (id) {
    select("u.name, COUNT(rounds.id) as rounds_count, c.name as club_name").
    joins("INNER JOIN users u on rounds.user_id = u.id").
    joins("INNER JOIN clubs c on u.club_id = c.id").
    where("rounds.competition_id = #{id}").
    group("u.id").
    order("u.name")
  }
end
