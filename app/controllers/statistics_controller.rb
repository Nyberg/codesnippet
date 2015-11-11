class StatisticsController < ApplicationController
  before_filter :stats
  include ApplicationHelper

  def index
    @data_type = params[:data_type] || "all"
    @data_content = params[:content] || "result"
    @graph_type = params[:graph] || "column"
    @graphs = stats.graph_types

    if @data_content == "result"
      if @data_type == "user"
        data = Score.user_results.by_user(current_user.id)
      else
        data = Score.user_results
      end
      @results = []
      types = []
      results = []
      data.each do |d|
        types << d.name
        results << d.total
      end
      @chart = stats.build_user_stats(@graph_type, types, results)
    else
      if @data_type == "user"
        current_user.rounds.count
        current_user.tour_parts.count
      else
        rounds = Round.all.count
        tour_parts = TourPart.all.count
        players = User.all.count
        types = ["Rundor", "Deltävlingar", "Spelare"]
      end

      @chart = stats.build_common_stats(@graph_type, rounds, tour_parts, players, types)
    end


  end

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

  def hole_stats
  end

end
