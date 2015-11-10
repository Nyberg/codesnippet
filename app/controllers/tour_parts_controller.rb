class TourPartsController < ApplicationController
  before_action :set_tour_part, only: [:show, :edit, :update, :destroy]
  before_filter :stats
  # GET /tour_parts
  # GET /tour_parts.json
  def index
    @tour_parts = TourPart.all
  end

  def stats
    @stats ||= Stats::StatsCommon.new
    @stats
  end

  # GET /tour_parts/1
  # GET /tour_parts/1.json
  def show
    @tour_part = TourPart.find(params[:id])
    @heading = @tour_part.name
    @tee = Tee.find(@tour_part.tee_id)
    @holes = Hole.where(tee_id: @tour_part.tee_id)
    @rounds = Round.where(tour_part_id: @tour_part.id).includes(:scores, :user, :holes, :tee)
    @scores = Score.where(tour_part_id: @tour_part.id).includes(:hole)
    check = Round.where(user_id: current_user.id, tour_part_id: @tour_part.id).first if current_user
    @headtohead = true if check
  end

  # GET /tour_parts/new
  def new
    @tour_part = TourPart.new
  end

  # GET /tour_parts/1/edit
  def edit
  end

  # POST /tour_parts
  # POST /tour_parts.json
  def create
    @tour_part = TourPart.new(tour_part_params)

    respond_to do |format|
      if @tour_part.save
        format.html { redirect_to admin_tours_path, notice: 'Tour part was successfully created.' }
        format.json { render :show, status: :created, location: @tour_part }
      else
        format.html { render :new }
        format.json { render json: @tour_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tour_parts/1
  # PATCH/PUT /tour_parts/1.json
  def update
    respond_to do |format|
      if @tour_part.update(tour_part_params)
        format.html { redirect_to admin_tours_path, notice: 'Tour part was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour_part }
      else
        format.html { render :edit }
        format.json { render json: @tour_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tour_parts/1
  # DELETE /tour_parts/1.json
  def destroy
    @tour_part.destroy
    respond_to do |format|
      format.html { redirect_to tour_parts_url, notice: 'Tour part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour_part
      @tour_part = TourPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_part_params
      params.require(:tour_part).permit(:name, :content, :course_id, :competition_id, :tee_id, :date)
    end
end
