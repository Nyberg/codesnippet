class Micropost < ActiveRecord::Base
	belongs_to :category
	belongs_to :user
	has_many :comments
	validates :content, length: {maximum: 1000}
end
