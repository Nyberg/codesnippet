class RoundsController < ApplicationController
  before_action :set_round, only: [:show, :edit, :update, :destroy]

  # GET /rounds
  # GET /rounds.json
  def index
    @rounds = Round.all
  end

  # GET /rounds/1
  # GET /rounds/1.json
  def show
    @round = Round.where(id: params[:id]).includes(:holes, :tour_part, :competition, :scores, :tee).first
    @user = User.where(id: @round.user_id).first
    @holes = Hole.where(tee_id: @round.tee_id)
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
  end

  # POST /rounds
  # POST /rounds.json
  def create
    @round = Round.new(round_params)
    tour_part = TourPart.find(@round.tour_part_id)

    @round.tee_id = tour_part.tee_id
    @round.course_id = tour_part.course_id
    @round.competition_id = tour_part.competition_id

    respond_to do |format|
      if @round.save
        User.where(id: @round.user_id).first.increment!(:rounds_count)
        format.html { redirect_to edit_score_path(@round.id), notice: 'Round was successfully created.' }
        format.json { render :show, status: :created, location: @round }
      else
        format.html { render :new }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1
  # PATCH/PUT /rounds/1.json
  def update
    respond_to do |format|
      if @round.update(round_params)
        format.html { redirect_to @round, notice: 'Round was successfully updated.' }
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit }
        format.json { render json: @round.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  # DELETE /rounds/1.json
  def destroy
    User.where(id: @round.user_id).first.decrement(:rounds_count, 1)
    @round.destroy
    respond_to do |format|
      format.html { redirect_to admin_round_path, notice: 'Round was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_round
      @round = Round.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def round_params
      params.require(:round).permit(:user_id, :course_id, :competition_id, :tee_id, :tour_part_id, :total, :division, :place)
    end
end
