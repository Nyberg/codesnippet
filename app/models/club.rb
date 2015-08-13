class Club < ActiveRecord::Base
  has_many :user
  has_many :competition
end
