class AdminsController < ApplicationController
  layout "application"

  before_action :admin

  def index
  end

  def users
    @users = User.by_name
    @users = @users.paginate(:page => params[:page], :per_page => 10)
  end

  def clubs
    @clubs = Club.all
  end

  def competitions
    @competitions = Competition.all
  end

  def imports
    @imports = Import.all
  end

  def tours
    @tour_parts = TourPart.all.by_date
    @tour_parts = @tour_parts.paginate(:page => params[:page], :per_page => 10)
  end

  def courses
    @courses = Course.by_name
  end

  def tees
    @tees = Tee.all.includes(:course)
  end

  def rounds
    @tour_parts = TourPart.all.includes(:rounds).order("date DESC")
    @tour_parts = @tour_parts.paginate(:page => params[:page], :per_page => 5)
  end

end
