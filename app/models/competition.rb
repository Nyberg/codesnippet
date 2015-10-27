class Competition < ActiveRecord::Base
  belongs_to :club
  has_many :tour_parts
  has_many :scores

  scope :by_name, -> {order(name: :asc)}
  scope :latest, -> {order(updated_at: :desc)}

end
