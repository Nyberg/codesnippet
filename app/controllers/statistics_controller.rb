class StatisticsController < ApplicationController
  before_filter :stats
  include ApplicationHelper

  def index
    @data_type = params[:data_type] || "all"
    @data_content = params[:content] || "result"
    @graph_type = params[:graph] || "column"
    @graphs = stats.graph_types

    if @data_content == "result"
      data = Score.user_results
      data = data.by_user(current_user.id) if @data_type == "user"

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
        rounds = Round.bogeyfree_rounds.by_user(current_user.id)
        bogeyfree_rounds = stats.bogeyfree_rounds(rounds).count
        rounds_count = current_user.rounds.count
        tour_parts = current_user.rounds.uniq(&:tour_part_id).count
        comps = current_user.rounds.map(&:competition_id).uniq
        below_par = Round.below_par.by_user(current_user.id)
        below_par = below_par.first.sum
      else
        rounds = Round.bogeyfree_rounds.group_by_round
        rounds_count = Round.all.count
        comps = Competition.all.count
        tour_parts = TourPart.all.count
        players = User.all.count
        types = ["Rundor", "Deltävlingar", "Spelare"]
        bogeyfree_rounds = stats.bogeyfree_rounds(rounds).count
        below_par = Round.below_par
        below_par = below_par.first.sum
      end

      @chart = stats.build_common_stats(@graph_type, rounds_count, comps, tour_parts, players, types, bogeyfree_rounds, below_par)
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

end
