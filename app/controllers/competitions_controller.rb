class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  before_filter :stats
  require 'set'
  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all
    @search = params[:term] || nil
    if @search
      @competitions = Competition.search(@search)
      @tags = Competition.tagged_with(@search)
    end
  end

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    @competition = Competition.where(id: params[:id]).first
    @page_title = "Startsida"
    # if @competition.tour_parts.count == 1
    #   tour = TourPart.where(competition_id: @competition.id).first
    #   redirect_to tour_part_path(tour.id)
    # end

    @heading = @competition.name
    @tour_parts = TourPart.where(competition_id: params[:id]).order("date DESC").includes(:course, :tee, :rounds)
    @tees = []

    @tour_parts.each do |tour|
      @tees << tour.tee
    end
    @tees = @tees.uniq(&:id)
  end

  def records
    @page_title = "Rekordrundor"
    @heading = "Rekordrundor"
    @competition = Competition.find(params[:id])
    @tees = Tee.where(id: @competition.tour_parts.uniq).includes(:rounds, :holes)
    rounds = Round.bogeyfree_rounds(@competition.id)
    @bogeyfrees = []
    rounds.each do |round|
      data = round.result_type.split(',')
      if data.include?("bogey" || "dblbogey" || "trpbogey" || "other")
      else
        @bogeyfrees << round
      end
    end
  end

  def totals
    @page_title = "Totalställning"
    @heading = "Totalställning"
    @competition = Competition.find(params[:id])
    @users = Round.competition_players(params[:id])
  end

  def statistics
    @page_title = "Statistik"
    @heading = "Statistik"
    @graph_type = params[:graph] || "spline"
    @data_type = params[:data_type] || "avg"
    @competition = Competition.find(params[:id])
    @all_scores = Score.where(competition_id: params[:id]).includes(:hole)
    @tour_parts = TourPart.where(competition_id: params[:id]).by_date
    @graphs = stats.graph_types

    if params[:tour_part]
      @tour_part = TourPart.find(params[:tour_part])
    else
      @tour_part = @tour_parts.first
    end

    @tee = Tee.find(@tour_part.tee_id)
    @holes = Hole.where(tee_id: @tee.id)

    if @data_type == "avg"
      numbers = stats.holes(@holes) # gets the hole numbers
      round = Round.where(tour_part_id: @tour_part.id, tee_id: @tee.id, place: 1).order("total ASC").limit(1) # gets the lowest score for the competition
      scores = Score.where(tour_part_id: @tour_part.id).includes(:hole)
      avg = Score.tour_part_avg(@tour_part.id) # gets average score for line graph
      avg = stats.tour_part_avg_score(avg)
      all_avg = Score.competition_avg(@competition.id, @tee.id)
      all_avg  = stats.tour_part_avg_score(all_avg)
      totals = stats.numbers(scores)

      check = Round.where(user_id: current_user.id, tour_part_id: @tour_part.id).first if current_user
      @headtohead = true if check

      if @headtohead
        head_scores = Score.where(user_id: current_user.id, tour_part_id: @tour_part.id)
        data = head_scores.map(&:score).to_a
        @chart = stats.tour_part_line_chart(@tour_part, numbers, @tee.color, data, @graph_type, avg, all_avg)
      else
        @chart = stats.tour_part_line_chart(@tour_part, numbers, @tee.color, @graph_type, avg, all_avg)
      end
    else
      @chart = stats.hole_bar_chart(@graph_type, @holes, @tour_part, @tee.color)
    end
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions
  # POST /competitions.json
  def create
    @competition = Competition.new(competition_params)

    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1
  # PATCH/PUT /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to @competition, notice: 'Competition was successfully updated.' }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1
  # DELETE /competitions/1.json
  def destroy
    @competition.destroy
    respond_to do |format|
      format.html { redirect_to competitions_url, notice: 'Competition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:competition).permit(:name, :title, :content, :club_id, :date, :tag_list)
    end
end
