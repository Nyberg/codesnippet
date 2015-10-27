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
    @round = Round.find(params[:format])
  end

  def edit
    @scores = Score.where(round_id: params[:id])
  end

  def create
    @score = Score.new(score_params)

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    scores = params[:scores]
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
      params.permit(:user_id, :round_id, :tee_id, :hole_id, :score, :competition_id)
    end
end
