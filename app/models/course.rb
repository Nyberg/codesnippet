class Course < ActiveRecord::Base

  belongs_to :club
  has_many :tees
  has_many :competitions
  has_many :rounds

  scope :by_name, -> {order(name: :asc)}
	scope :search, -> (term) {
    joins("INNER JOIN clubs c on courses.club_id = c.id").
    where("courses.name LIKE ? or c.name LIKE ?", *(["%#{term}%"])*2)
  }

end
