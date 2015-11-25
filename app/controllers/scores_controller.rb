class ScoresController < ApplicationController
  include ApplicationHelper
  before_action :set_score, only: [:show, :destroy]

  def index
    @scores = Score.all
  end

  def show
  end

  def new
    @score = Score.new
    @round = Round.find(params[:id])
  end

  def edit
    @scores = Score.where(round_id: params[:id])
    @round = Round.find(params[:id])
  end

  def create
    scores = params[:scores].split(' ')
    total_score = 0
    @round = Round.find(params[:round_id])
    @round.tee.holes.each_with_index do |hole, index|
      num = scores[index].to_i
      result_type = get_score(num, hole.par)
      result_id = get_result_id(num, hole.par)
      Score.create(round_id: @round.id, hole_id: hole.id, tee_id: hole.tee_id, user_id: @round.user_id, score: num, tour_part_id: @round.tour_part_id, competition_id: @round.competition_id, result_type: result_type, result_id: result_id)
      total_score = total_score + num
    end
    @round.total = total_score
    @round.save!
    redirect_to admin_tours_path, notice: 'Score was successfully created.'
  end

  def update
    # Updating multiple records:
    Score.update(scores.keys, scores.values)
    scores = Score.where(id: scores.keys).includes(:hole)
    scores.each do |s|
      s.result = get_score(s.score, s.hole.par)
      s.save!
    end
    redirect_to admin_round_path, notice: 'Score was successfully updated.'
  end

  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.permit(:user_id, :round_id, :tee_id, :hole_id, :score, :competition_id, :ob, :tour_part_id, :result, :result_id)
    end
end
