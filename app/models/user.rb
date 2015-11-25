class User < ActiveRecord::Base
	belongs_to :club
	has_many :rounds
	has_many :scores

	scope :by_name, -> {order(name: :asc)}
	scope :clubs, -> { joins("INNER JOIN clubs c on users.club_id = c.id ")}
	scope :search, -> (term) { where("users.first_name LIKE ? or users.last_name LIKE ? or users.name LIKE ? or users.pdga LIKE ? or c.name LIKE ?", *(["%#{term}%"]*5)) }

	attr_accessor :remember_token

	#before_save { self.email = email.downcase }
  	validates :name, presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  	has_secure_password
  	validates :password, presence: false, length: { minimum: 0 }, on: :create

  	def User.digest(string)
  		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
  	end

  	def User.new_token
  		SecureRandom.urlsafe_base64
  	end

  	def remember
  		self.remember_token = User.new_token
  		update_attribute(:remember_digest, User.digest(remember_token))
  	end

  	def authenticated?(remember_token)
  		BCrypt::password.new(remember_digest).is_password?(remember_token)
  	end

  	def forget
  		update_attribute(:remember_digest, nil)
  	end
end
