class AdminsController < ApplicationController
  layout "application"

  before_action :admin

  def index
  end

  def users
    @users = User.all
  end

  def clubs
    @clubs = Club.all
  end

end
