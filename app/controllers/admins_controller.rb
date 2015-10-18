class AdminsController < ApplicationController
  layout "application"

  before_action :admin

  def index
  end

  def users
    @users = User.by_name
  end

  def clubs
    @clubs = Club.all
  end

  def competitions
    @competitions = Competition.all
  end

  def courses
    @courses = Course.by_name
  end

  def tees
    @tees = Tee.all.includes(:course)
  end

  def rounds
    @rounds = Round.all
  end

end
