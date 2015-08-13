class Competition < ActiveRecord::Base
  belongs_to :club
  has_many :tour_parts

  scope :by_name, -> {order(name: :asc)}
  scope :latest, -> {order(updated_at: :desc)}

end
