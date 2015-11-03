class Course < ActiveRecord::Base

  belongs_to :club
  has_many :tees
  has_many :competitions
  has_many :rounds

  scope :by_name, -> {order(name: :asc)}

end
