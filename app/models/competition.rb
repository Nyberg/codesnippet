class Competition < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :tags

  belongs_to :club
  has_many :tour_parts
  has_many :scores

  scope :by_name, -> {order(name: :asc)}
  scope :latest, -> {order(updated_at: :desc)}
  scope :search, -> (term) { where("name LIKE '%#{term}%'") }

end
