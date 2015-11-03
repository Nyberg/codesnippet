class StatisticsController < ApplicationController
  before_filter :stats

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  def headtohead
    @tour_part = TourPart.where(id: params[:tour_part]).first
    @holes = Hole.where(tee_id: @tour_part.tee_id)
    @user = User.where(id: params[:user]).first
    @order = params[:order] || "inverse"
    @rounds = []
    @rounds << Round.where(tour_part_id: @tour_part.id, user_id: current_user.id).includes(:scores).first
    @rounds << Round.where(tour_part_id: @tour_part.id, user_id: @user.id).includes(:scores).first
    @data = []
    @rounds.each do |round|
      data = stats.get_head_to_head(round)
      @data << data
    end
    @data.flatten(2)


    @rounds = @rounds.reverse if @order == "reverse"
    @rounds = @rounds if @order == "inverse"

  end

end
