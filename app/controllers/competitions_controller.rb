class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:show, :edit, :update, :destroy]
  before_filter :stats
  require 'set'
  # GET /competitions
  # GET /competitions.json
  def index
    @competitions = Competition.all
  end

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  # GET /competitions/1
  # GET /competitions/1.json
  def show
    @competition = Competition.find(params[:id])
    @page_title = "Startsida"
    @heading = @competition.name

    if @competition.tour_parts.count == 1
      tour = TourPart.where(competition_id: @competition.id).first
      redirect_to tour_part_path(tour.id)
    end
  end

  def records
    @page_title = "Rekordrundor"
    @heading = "Rekordrundor"
    @competition = Competition.find(params[:id])
    @tees = Tee.where(id: @competition.tour_parts.uniq).includes(:rounds, :holes)
    rounds = Round.bogeyfree_rounds(@competition.id)
    @bogeyfrees = []
    rounds.each do |round|
      data = round.result.split(',')
      if data.include?("bogey" || "dblbogey" || "trpbogey" || "other")
      else
        @bogeyfrees << round
      end
    end
  end

  def statistics
    @page_title = "Statistik"
    @heading = "Statistik"
    @competition = Competition.find(params[:id])
    @all_scores = Score.where(competition_id: params[:id]).includes(:hole)

    tees = []

    @competition.tour_parts.each do |tour|
      tees << Tee.where(id: tour.tee_id).first
    end
    @tees = tees.uniq

    avg = []
    numbers = []
    totals = []
    @line_charts = []
    @pie_charts = []

    @tees.each do |tee|
      avg = []
      numbers = []
      totals = []
      avg = stats.competition_round_stats(@competition.id, tee.id) # gets average score for line graph
      numbers = stats.holes(tee.holes) # gets the hole numbers
      round = Round.where(competition_id: @competition.id, tee_id: tee.id, place: 1).order("total ASC").limit(1) # gets the lowest score for the competition
      low = stats.competition_high_low(round)
      @line_charts << stats.competition_line_chart(@competition, avg, numbers, tee.color, low)
      scores = Score.where(competition_id: @competition.id).where(tee_id: tee.id).includes(:hole)
      totals = stats.numbers(scores)
      @pie_charts << stats.competition_pie_chart(totals, "Resultat #{tee.color} tee")
    end
    all_totals = stats.numbers(@all_scores) # gets the total results for the competition (birdies, pars etc)
    @pie_chart_total = stats.competition_pie_chart(all_totals, "Totalt för #{@competition.name}")
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
      params.require(:competition).permit(:name, :title, :content, :club_id, :date)
    end
end
